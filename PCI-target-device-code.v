module PCI_target(clk, reset_low, Frame, AD_Line, C_BE, IRDY, TRDY, Dev_Sel,s) ;
input clk ;
input reset_low;
input Frame ;
inout [31:0] AD_Line;
input [3:0]C_BE;
input IRDY;
output reg  TRDY ;
output reg  Dev_Sel  ;
output reg s; /////stop 
//////////////////////
reg [31:0] Memorys [0:3];
reg [31:0] Memory [0:9];
reg [31:0] index ;
reg [31:0] newindex ;
reg [31:0] AD_Line_reg;
reg [3:0] C_BE_reg;
reg [3:0] C_BE_reg2;
//////////////////////
reg [0:3] no_data = 4'b0000;
reg flag1;
reg [1:0]flag2;
reg done2=0;
reg [3:0]a=4'b0000; ///// flag for stop
reg [1:0]stopflag =2'b00 ;
/////////////////////
parameter Read_Operation=4'b0110,        
			 Write_Operation=4'b0111;

assign AD_Line = (flag2[1]==1 && TRDY ==0 ) ?   (AD_Line_reg) : 32'hz;


initial
		
		
		
		
		
		
			begin
				
				TRDY=1'b1 ;
				Dev_Sel  =1'b1;
	   		index = 0;  
				flag2[0]=1'b0;
				flag2[1]=1'b0;
				s=1;
				end

always@(!reset_low) begin 
TRDY <= 1 ; 
Dev_Sel <= 1 ;
index=0;
            Memory [0]=0;
            Memory [1]=0; 
				Memory [2]=0;
				Memory [3]=0;
				Memory [4]=0;
				Memory [5]=0;
				Memory [6]=0;
				Memory [7]=0;
				Memory [8]=0;
				Memory [9]=0;
				Memorys [0]=0;
				Memorys [1]=0;
				Memorys [2]=0;
				Memorys [3]=0;
end
always@(negedge clk)
begin 
//////////////////////////
if (no_data== 4 && a!=11)
begin 
 stopflag = stopflag +1;
TRDY=1;
		  @(posedge clk) @(negedge clk) TRDY=0;
		  no_data=0;
end

if(Frame==1) begin
 no_data=0;
 stopflag = 0 ;
 end
 
 
///////////////////////////

if (done2) begin Dev_Sel =0 ; TRDY=0;done2=0;end

///////////////////////////////
if((C_BE_reg==Read_Operation))  	
					begin
				
					 AD_Line_reg = Memorys[index]   ;
					 flag2[1] =1;

					 if (IRDY==0) begin
					index = index + 1;
					 end
					 				
		if (index > 3) begin 
		index=0; 
      end 		 
					 
					 end
//////////////////////////////	

	if (a == 11 )
begin 

s = 0;
		  
		  no_data=0;
        stopflag = 0 ;		  
		 @(posedge clk)@(negedge clk) TRDY=1; 
	
		  
end

end ///always


always@(posedge clk)

begin
//////////////////


////////////////
if(IRDY == 0&&TRDY == 0)

begin
C_BE_reg2 = C_BE;
			
					if (C_BE_reg == Write_Operation )
					begin 
					
					if(C_BE_reg2[0]) begin Memorys[newindex][7:0] = AD_Line[7:0];end
					if(C_BE_reg2[1]) begin Memorys[newindex][15:8] = AD_Line[15:8];end
					if(C_BE_reg2[2]) begin Memorys[newindex][23:16] = AD_Line[23:16];end
					if(C_BE_reg2[3]) begin Memorys[newindex][31:24] = AD_Line[31:24]; end
           		no_data = no_data + 1;
				   newindex <= newindex + 1;
					a=a+1;
					
				if (newindex==3)
				begin newindex<=0;end
	
				//////////////////////
			 if (no_data == 4)
				begin 
				if(stopflag == 0)
				begin
		 Memory[0]<= Memorys[0];
		 Memory[1]<= Memorys[1];
		 Memory[2]<= Memorys[2];
		 Memory[3]<= Memorys[3];
		 
            end	
				if(stopflag == 1)
				begin
		 Memory[4]<= Memorys[0];
		 Memory[5]<= Memorys[1];
		 Memory[6]<= Memorys[2];
		 Memory[7]<= Memorys[3];
	
            end	

	   		end		

				
			      ///////////////////
				
				flag2[1] =0;
	end			
end	

/////////////////////////////////	 
if (Frame ==0 && flag2[0] ==0)
			begin 
					 
			  C_BE_reg= C_BE;  //// for control line
           if ((newindex ==0) || (newindex ==3)||(newindex >0&&newindex<3)  )
							begin 
							flag1=1; end  ////trdy &devsel
flag2[0] =1;    
C_BE_reg =C_BE;
index=AD_Line-1; //for read (-1) bec. of the turn around 
newindex=AD_Line;
			end //first cycle with the frame =0 

			
//////////////////////////////

if (IRDY ==0) begin 
	 done2 =1; end

if (Frame ==1 ) begin flag2[0]=0;  end
///////////////////////

 end  //always



always @(negedge clk)
begin 
if(Frame==1)
begin
if (C_BE_reg == Write_Operation ) begin
TRDY=1; Dev_Sel=1; end
@(posedge clk) @(negedge clk) TRDY=1; Dev_Sel=1;
end
//////////////////

end //always


endmodule 