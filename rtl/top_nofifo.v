module top_nofifo (
           input wire clk,
           input wire rst,
           input wire valid_i,
           input wire ready_i,

           input wire [7: 0] din,

           output wire [7: 0] dout,
           output wire ready_o,
           output wire valid_o
       );

reg valid_r1;
wire ready_r1;
reg [7: 0]din_r;
reg valid_r2;
wire ready_r2;
reg valid_r3;

reg [7 : 0] din_rr;
reg [7 : 0] din_rrr;

assign ready_o = ~valid_r1 || ready_r1;


always @ (posedge clk or negedge rst)
	begin
		if (!rst)
			begin
				valid_r1 <= 1'b0;
			end
		else if (ready_o)
			begin
				valid_r1 <= valid_i;
			end
	end

always @ (posedge clk)
	begin
		if (ready_o & valid_i)
			begin
				din_r <= din;
			end
	end

assign ready_r1 = ~valid_r2 || ready_r2;



always @ (posedge clk or negedge rst)
	begin
		if (!rst)
			begin
				valid_r2 <= 1'b0;
			end
		else if (ready_r1)
			begin
				valid_r2 <= valid_r1;
			end
	end

always @ (posedge clk)
	begin
		if (ready_r1 & valid_r1)
			begin
				din_rr <= din_r;
			end
	end

assign ready_r2 = ~valid_r3 || ready_i;



always @ (posedge clk or negedge rst)
	begin
		if (!rst)
			begin
				valid_r3 <= 1'b0;
			end
		else if (ready_r2)
			begin
				valid_r3 <= valid_r2;
			end
	end

always @ (posedge clk)
	begin
		if (ready_r2 & valid_r2)
			begin
				din_rrr <= din_rr;
			end
	end

assign dout = din_rrr;
assign valid_o = valid_r3;
endmodule
