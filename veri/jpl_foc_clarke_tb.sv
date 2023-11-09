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
// ENGINEER: Jinseong Lee (jinseong.lee@jpl.nasa.gov)
// CREATED: 2023-11-07
//
// FILENAME: jpl_foc_clarke_tb.sv
//
// DESCRIPTION: Unit test for foc_clarke.
//                o_ia = i_ia                    = Isin(wt)
//                o_ib = (i_ia + 2*i_ib)/sqrt(3) = Isin(wt + pi/2)

// SUPPORTING DOCUMENTATION: 
// - README.md
//
// DEPENDENCIES: None
//
// REVISION HISTORY:
// REVISION HISTORY:
// - 2023-11-07    J.Lee     Initial version

////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module jpl_foc_clarke_tb #(
    //parameter            B    = 12    
    parameter            B    = 4    //test case 
    
  ); 
  //parameters
    localparam          SYSCLK_PERIOD               = 10;// 100MHZ
    
    localparam          init_i_adc_raw              = 4; 
    localparam          toggle_dly_i_rst_n          = 'd2;
    localparam          toggle_dly_i_start_clarke   = 'd2;

    logic                   i_clk          ;
    logic                   i_rst_n        ;
  
    logic                   i_start_clarke ;
    logic                   o_clarke_done  ;
    logic signed [B-1:0]    i_ia           ;  
    logic signed [B-1:0]    i_ib           ;  
    logic signed [B-1:0]    o_ialpha       ;  
    logic signed [B-1:0]    o_ibeta        ;  

    logic [B+2:0]   s_cnt_clk        ;
    
    initial begin 
        $timeformat(-9, 0, " ns");
        $display("=========== START============");
        
        i_clk           = 1'b1;    
        i_rst_n         = 1'b0;
        s_cnt_clk       = 'b0;

        i_start_clarke  = 1'b0;
        i_ia            = -'sd4;
        i_ib            = -'d4;
        
        
        #(SYSCLK_PERIOD*2);  
            i_rst_n     = 1'b1;

        #(SYSCLK_PERIOD*2); 
            i_start_clarke = 1'b1;

        #(SYSCLK_PERIOD); 
            i_start_clarke = 1'b0;
    end

 
    always
        #(SYSCLK_PERIOD/2) i_clk <= !i_clk;
   
    // update raw_data 
    always @ (posedge i_clk) begin 
        if(!i_rst_n) begin
			s_cnt_clk     <= 0;
        end
        else begin
            s_cnt_clk <= s_cnt_clk + 1;

            if (s_cnt_clk == {(B){1'b1}}) begin
                s_cnt_clk <='b0;
            end
    
            i_ib <= i_ib + 1;
        end
    end


  //=================  Instantiate =================  
    jpl_foc_clarke
    #(
        .B  (B)
    )  jpl_foc_clarke  
    (
        // Inputs
        .i_clk          (i_clk)             ,         
        .i_rst_n        (i_rst_n)           ,         
        .i_start_clarke (i_start_clarke)    ,
        .i_ia           (i_ia)              ,      
        .i_ib           (i_ib)              ,
        .o_clarke_done  (o_clarke_done)     ,
        .o_ialpha       (o_ialpha)          ,
        .o_ibeta        (o_ibeta)          
    );
  
endmodule