`timescale 1ns / 1ps

//同步fifo
module fifo
#
(
	parameter		depth = 40,
	parameter		width = 8
)
(
	input				clk,
	input				rst_n,
	input				wr_en,
	input	[width-1:0]	data_in,

	input				rd_en,
	output	[width-1:0]	data_out,

	output				full,
	output				empty

);

reg	[width-1:0]	mem	[depth-1:0];
reg	[$clog2(depth):0]		waddr;			
reg	[$clog2(depth):0]		raddr;			
reg	[width-1:0]	temp_rdata;



always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		waddr <= 0;
	else if(wr_en == 1'b1)
		waddr <= waddr + 1;
	else
		waddr <= waddr;
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		raddr <= 0;
	else if(rd_en == 1'b1)
		raddr <= raddr + 1;
	else
		raddr <= raddr;
end


always@(posedge clk)
begin
	if(!full )
		mem[waddr] <= data_in;
	else
		mem[waddr] <= mem[waddr];
end


assign	data_out = temp_rdata;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		temp_rdata <= { width{ 1'b0}};
	else if(!empty)
		temp_rdata <= mem[raddr];
	else
		temp_rdata <= temp_rdata ;
end

assign	empty = (waddr == raddr)?1'b1:1'b0;

assign	full = ({ ~waddr[$clog2(depth)],waddr[$clog2(depth)-1:0]} == raddr)?1'b1:1'b0;

endmodule
