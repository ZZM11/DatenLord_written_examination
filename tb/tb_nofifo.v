`timescale 1ns / 1ps


module tb_nofif();


reg clk;
reg rst_n;
always	#5	clk = ~clk;
reg [7: 0] data_in;
wire ready_o;

always #15
	begin
		if (ready_o)
			data_in = data_in + 1'b1;
		else
			data_in = data_in;
	end


reg valid_i;
reg ready_i;

wire valid_o;
wire [7: 0] data_out;

initial
	begin
		clk <= 1'b1;
		rst_n <= 1'b0;
		//busy信号控制接受端工作状态
		// busy <= 1'b0;
		data_in <= 0;
		ready_i <= 0;
		valid_i <= 1'b0;

		#20
		 rst_n <= 1'b1;
		ready_i <= 1'b1;
		valid_i <= 1'b1;

		#100
		 ready_i <= 1'b0;
		#150
		 ready_i <= 1'b1;
	end

top_nofifo u_top_nofifo(
               .clk ( clk ),
               .rst ( rst_n ),
               .valid_i ( valid_i ),
               .ready_i ( ready_i ),
               .din ( data_in ),
               .dout ( data_out ),
               .ready_o ( ready_o ),
               .valid_o ( valid_o )
           );

endmodule
