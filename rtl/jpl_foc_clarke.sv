////////////////////////////////////////////////////////////////////////////////
// COPYRIGHT 2023, BY THE CALIFORNIA INSTITUTE OF TECHNOLOGY. ALL RIGHTS 
// RESERVED. UNITED STATES GOVERNMENT SPONSORSHIP ACKNOWLEDGED. ANY COMMERCIAL 
// USE MUST BE NEGOTIATED WITH THE OFFICE OF TECHNOLOGY TRANSFER AT THE 
// CALIFORNIA INSTITUTE OF TECHNOLOGY.
// 
// THIS SOFTWARE MAY BE SUBJECT TO U.S. EXPORT CONTROL LAWS AND REGULATIONS. BY 
// ACCEPTING THIS DOCUMENT, THE USER AGREES TO COMPLY WITH ALL APPLICABLE U.S. 
// EXPORT LAWS AND REGULATIONS. USER HAS THE RESPONSIBILITY TO OBTAIN EXPORT 
// LICENSES, OR OTHER EXPORT AUTHORITY AS MAY BE REQUIRED, BEFORE EXPORTING SUCH 
// INFORMATION TO FOREIGN COUNTRIES OR PROVIDING ACCESS TO FOREIGN PERSONS.
// 
// DESIGN: IP
// PROJECT: JPL IP Library
// COMPANY: Jet Propulsion Laboratory
// ENGINEER: Jinseong Lee (jinseong.lee@jpl.nasa.gov),
//           Ryan Stern (ryan.a.stern@jpl.nasa.gov)
// CREATED:
//
// FILENAME: jpl_foc_clarke.sv
//
// DESCRIPTION: 
// Processes         Clarke transform (current): applying 3   phases to 2 phases from            (a,b)        to            (alpha -beta)
//
//                o_ia = i_ia                    = Isin(wt)
//                o_ib = (i_ia + 2*i_ib)/sqrt(3) = Isin(wt + pi/2)
// 
//---------- to be added -------------
// Processes         Park   transform (current): applying 2   phases to 2 phases from stationary (alpha,beta) to rotating   (d,q)
// Processes Inverse Park   transform (voltage): applying 2   phases to 2 phases from rotating          (d,q) to stationary (alpha,beta)
// Processes Inverse Clarke transform (voltage): applying 2   phases to 3 phases from           (alpha,beta)  to stationary (a,b)

//
// PORTS:
// ============ Outputs: ==============
// ---------- Clarke -----------
// - o_ialpha[B-1:0] : Processed Clarke Phase alpha current output.  Two's complement. Signed
// - o_ibeta [B-1:0] : Processed Clarke Phase beta current output.   Two's complement. Signed
// - o_clarke_done   : Asserts for one clock when Clarke transform is complete.

// ============== Inputs: ==============
// - i_clk          : Module clock
// - i_rst_n        : Active-low module reset          

// ---------- Clarke -----------
// - i_ia[B-1:0]    : Raw ADC value for Phase A current input. Signed
// - i_ib[B-1:0]    : Raw ADC value for Phase B current input. Signed
// - i_start_clarke : assert for one clock to start calibration         

//
// Parameters:
// - B : Bit width of raw a,b current input(s) and output(s)


// SUPPORTING DOCUMENTATION: 
// - <supporting documentation>
//
// DEPENDENCIES: None
//
// REVISION HISTORY:
// - 2023-11-07    J.Lee     Initial version

////////////////////////////////////////////////////////////////////////////////

module jpl_foc_clarke #(
  // parameter            B        = 12         
  parameter            B        = 4 // test case         
  )(
    // ------- input ---------------  
    input      logic                  i_clk               ,
    input      logic                  i_rst_n             ,

    input      logic                  i_start_clarke      ,

    //Clarke
    input      logic signed [B-1:0]   i_ia                ,  
    input      logic signed [B-1:0]   i_ib                ,  
    
    output     logic                  o_clarke_done       ,
    output     logic signed [B-1:0]   o_ialpha            , 
    output     logic signed [B-1:0]   o_ibeta
  );

  logic signed [  B:0]	           b_latched_sum, b_latched;
  logic signed [B+B:0]	           b_latched_2;

  //delay
  logic               	           s_start_clarke_d1,
                                   s_start_clarke_d2;

  logic             	             s_clarke_valid;
  logic         	                 s_output_valid;
  logic        [B:0]             s_cnt_valid_i_clarke_raw;

  // delay
  always_ff @ (posedge i_clk or negedge i_rst_n) begin 
      if(!i_rst_n) begin 
          s_start_clarke_d1 <= 1'b0;                   
          s_start_clarke_d2 <= 1'b0;                   
      end
      else begin
          s_start_clarke_d1 <= s_clarke_valid;     
          s_start_clarke_d2 <= s_start_clarke_d1;     
      end
  end

  
  assign b_latched      = (B+1)'(i_ib<<1); // = 2*i_ib

  always_ff @(posedge i_clk, posedge i_rst_n) begin
		if(!i_rst_n) begin
        s_clarke_valid     <= 0;
		end 
    else begin
      if(i_start_clarke == 1'b1 ) begin
        s_clarke_valid     <=1'b1;
      end
    end
  end

  always_ff @(posedge i_clk, posedge i_rst_n) begin
    if(!i_rst_n) begin   
            s_cnt_valid_i_clarke_raw <= 'd0;       
    end                                     
    else begin
        if( s_clarke_valid == 1'b1 ) begin
            s_cnt_valid_i_clarke_raw <= s_cnt_valid_i_clarke_raw+ 1;
        end 
        else begin
            s_cnt_valid_i_clarke_raw <= s_cnt_valid_i_clarke_raw; 
        end
    end
  end

  // transformation
  always_ff @(posedge i_clk, posedge i_rst_n) begin
		if(!i_rst_n) begin
      b_latched_2     <= 0;
      b_latched_sum     <= 0;
		end 
    else begin
      if(s_clarke_valid == 1'b1 ) begin
      
        // i_ia + 2*i_ib
        b_latched_sum   <= i_ia + b_latched;
        
        // test 1 for B=12
        // numerator: i_ia + 2*i_ib
        // =====================  square root test ============================
        // 1/sqrt(3)    = 0.57735(base 10)   = 0.100100111100(binary-12 digits)
        // b_latched_2  <= (B+B+1)'(b_latched_sum<<11) + (B+B+1)'(b_latched_sum<<8) +
        //                 (B+B+1)'(b_latched_sum<<5)  + (B+B+1)'(b_latched_sum<<4) +
        //                 (B+B+1)'(b_latched_sum<<3)  + (B+B+1)'(b_latched_sum<<2);//okay

        //test 2 for for B=4
        // denominator: 1/sqrt(3)    = 0.57(base 10)   = 0.1001(binary-4 digits)
        b_latched_2     <= (B+B+1)'(b_latched_sum<<3) +         
                                                        (B+B+1)'(b_latched_sum<<0);//okay
      end
		end
	end

   always_ff @(posedge i_clk, posedge i_rst_n) begin
		if(!i_rst_n) begin
        o_clarke_done   <= 0;
		end 
    else begin
      if(s_cnt_valid_i_clarke_raw == {(B){1'b1}} ) begin //edit
        o_clarke_done   <= 1'b1;
      end
      else
        o_clarke_done   <= 1'b0;
    end
  end

  assign o_ialpha       = i_ia;
  assign o_ibeta      	= B'(b_latched_2 >>4) ;
  
  
endmodule




