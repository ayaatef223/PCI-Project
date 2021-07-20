module TESTBENCH();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;


/// scenario 1 (check address)
#5
reset_low<=1;
Frame = 0 ;
IRDY = 1 ;
i= 4 ;
C_BE = 4'b0111; // write
#10
i= 4;
IRDY = 0 ;
C_BE =4'b1111  ; 
#10
i= 4;
C_BE =4'b1111  ;
Frame = 1;
#10
IRDY = 1 ;



end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule

///////////////////////////////////////////////////////////////////////
module TESTBENCH2();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

  
/// scenario 2 (reset for initialization)

#5
reset_low<=1;
i= 0 ;   //address al device
Frame=0;
C_BE = 4'b0110 ; // read
#10 //turnaround
i= 32'hz;
IRDY = 0 ;
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
Frame=1;
#10
IRDY=1;

end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule
///////////////////////////////////////////////////
module TESTBENCH3();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

/// scenario 3   (initialization ,write , read)

#5
reset_low<=1;
Frame = 0 ;
IRDY = 1 ;
i= 0 ;
C_BE = 4'b0111; // write
#10
i= 2;
IRDY = 0 ;
C_BE =4'b1111  ; 
#20
i= 4;
C_BE =4'b1111  ;
#10
i<= 8;  //data3  
C_BE <=4'b1111  ;
#10
i= 16;  //data4  
C_BE =4'b1111  ;
Frame<=1;
C_BE <=4'b1111  ;
#10
IRDY<=1;
///////////
#10
i= 0 ;   //address al device
Frame=0;
C_BE = 4'b0110 ; // read
#10 //turnaround
i= 32'hz;
IRDY = 0 ;
C_BE = 4'b1111 ;
////////////
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
Frame=1;
#10
IRDY=1;

end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule
/////////////////////////////////////////////////////
module TESTBENCH4();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

/// scenario 4  (write and changing byte enable)

#5
reset_low<=1;
Frame = 0;
IRDY = 1;
i= 0;
C_BE = 4'b0111; // write
#10
i= 32'hffffffff; //data1
IRDY = 0;
C_BE =4'b1110;
#20
i= 32'hffffffff; //data2
C_BE =4'b1101;
#10
i= 32'hffffffff; //data3  
C_BE <=4'b1011;
#10
i= 32'hffffffff; //data4
Frame<=1;
C_BE <=4'b0111;
#10
IRDY<=1;

end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule
//////////////////////////////////////////
module TESTBENCH5();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

/// scenario 5  (read and change IRDY)
#5
reset_low<=1;
Frame = 0 ;
IRDY = 1 ;
i= 0 ;
C_BE = 4'b0111; // write
#10
i= 2; //data1
IRDY = 0 ;
C_BE =4'b1111  ;
#20
i= 4;  //data2
C_BE =4'b1111  ;
#10
i<= 8;  //data3  
C_BE <=4'b1111  ;
#10
i= 16;  //data4   
Frame<=1;
C_BE <=4'b1111  ;
#10
IRDY<=1;
#20
i= 0;    //address al device
Frame=0;
C_BE = 4'b0110; // read
#10 //turnaround
i= 32'hz;
IRDY = 0;
C_BE = 4'b1111;
#10
C_BE = 4'b1111;
#10
IRDY=1;
#10
IRDY=0;
#10
C_BE = 4'b1111;
#10
C_BE = 4'b1111;
Frame=1;
#10
IRDY=1;

end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule
/////////////////////////////////////////////
module TESTBENCH6();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

/// scenario 6 (write and change TRDY)+ apply C_BE 
#5
reset_low<=1;
Frame = 0 ;
IRDY = 1 ;
 i= 0 ;
C_BE = 4'b0111; // write
#10 
 i= 1; /// data1
IRDY = 0 ;
C_BE =4'b1111  ;   
#20
i= 2; /// data2
C_BE =4'b1110  ;
#10
i<= 3;  //data3  
C_BE <=4'b1111  ;
#10
i= 4;  //data4  
C_BE =4'b1111  ;
#10
i= 5;  //data5  
C_BE =4'b1111  ;
#20
i= 6;  //data6  
C_BE =4'b1110  ;
#10
Frame<=1;
i<=7;  //data7
C_BE <=4'b1111  ;
#10
IRDY<=1;

end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule
////////////////////////////////////////////
module TESTBENCH7();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

/// scenario 7 (write, read, and change TRDY)
#5
reset_low<=1;
Frame = 0 ;
IRDY = 1 ;
 i= 0 ;
C_BE = 4'b0111; // write
#10
 i= 2; //data1
IRDY = 0 ;
C_BE =4'b1111  ;
#20
i= 4;  //data2
C_BE =4'b1111  ;
#10
i<= 8;  //data3  
C_BE <=4'b1111  ;
#10
i= 16;  //data4  
C_BE =4'b1111  ;
#10
i= 32;  //data5  
C_BE =4'b1111  ;
#20
i= 64;  //data6  
Frame<=1;
C_BE <=4'b1111  ;
#10
IRDY<=1;
#20
i= 0 ;   //address al device
Frame=0;
C_BE = 4'b0110 ; // read
#10 //turnaround
i= 32'hz;
IRDY = 0 ;
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
Frame=1;
#10
IRDY=1;

end
endmodule
///////////////////////////////////////
module TESTBENCH8();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

/// scenario 8 (write, read, and change IRDY, TRDY)
#5
reset_low<=1;
Frame = 0 ;
IRDY = 1 ;
 i= 0 ;
C_BE = 4'b0111; // write
#10
 i= 1;
IRDY = 0 ;
C_BE =4'b1111  ;   
#20
i= 2;
C_BE =4'b1111  ;
#10

i<= 3;  //data3  
C_BE <=4'b1111  ;
#10
i= 4;  //data4  
C_BE =4'b1111  ;
#10
i= 5;  //data5  
C_BE =4'b1111  ;
#20
i= 6;  //data6  
C_BE =4'b1111  ;
#10
Frame<=1;
i<=7;  //data7
C_BE <=4'b1111  ;
#10
IRDY<=1;
#20
i= 0 ;   //address al device
Frame=0;
C_BE = 4'b0110 ; // read
#10 //turnaround
i= 32'hz;
IRDY = 0 ;
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
#10
IRDY=1;
#10
IRDY=0;
#10
C_BE = 4'b1111 ;
#10
C_BE = 4'b1111 ;
Frame=1;
#10
IRDY<=1;
end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule 
/////////////////////////////////////////////////

module TESTBENCH9();
reg clk;
reg reset_low ;
reg Frame;
wire[31:0] AD_Line ;
reg [3:0] C_BE;
reg IRDY ;
reg [31:0] i ;
assign AD_Line = i;

initial
begin
clk  = 1 ;
Frame = 1 ; 
IRDY = 1 ;
reset_low<=0; 

i= 32'hzzzzzzzz;
C_BE = 4'bzzzz ;

#5
reset_low<=1;
Frame = 0 ;
IRDY = 1 ;
 i= 0 ;
C_BE = 4'b0111; // write
#10
 i= 1;
IRDY = 0 ;
C_BE =4'b1111  ;   
#20
i= 2;
C_BE =4'b1111  ;

#10
i<= 3;  //data3  
C_BE <=4'b1111  ;

#10
i= 4;  //data4  
C_BE =4'b1111  ;
#10
i= 5;  //data5  
C_BE =4'b1111  ;
#20
i= 6;  //data6  
C_BE =4'b1111  ;
#10
i= 7;  //data7  
C_BE =4'b1111  ;
#10 
i= 8;  //data8  
C_BE =4'b1111  ;
#10
i= 9;  //data9  
C_BE =4'b1111  ;
#20
i<=10;  //data10
C_BE <=4'b1111  ;
#10
i= 11;  //data11  
C_BE =4'b1111  ;
//Frame<=1; 
#10
i= 12;  //data12  
C_BE =4'b1111  ;
 
#10
Frame<=1;
#10
IRDY<=1;



end

PCI_target device1(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s);
always
begin
#5 clk =(~clk );
end
endmodule 