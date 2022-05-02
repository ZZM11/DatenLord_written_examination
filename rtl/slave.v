module salve(
           clk,
           rst_n,
           valid,
           data_in_s,

           ready,
           data_out_s,
           busy
       );

parameter num = 8;
input clk;
input rst_n;
input valid;
input [num - 1: 0] data_in_s;
input busy;

output reg ready;
output reg [num - 1: 0] data_out_s;


reg valid_r;

always@(posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			valid_r <= 1'b0;
		else
			valid_r <= valid;
	end

always@(posedge clk or negedge rst_n or posedge busy)
	begin
		if (!rst_n)
			begin
				ready <= 1'b0;
				data_out_s	<= 0;

			end
		else
			begin //在检测到主机数据无效的时候，准备就绪接收数据
				ready <= (busy)?1'b0:(data_out_s == data_in_s) ? 1'b1 : 1'b0;
				data_out_s	<= (valid_r == 1'b1&&busy==1'b0) ? data_in_s : data_out_s;
			end
	end

always@(*)
begin
    if(busy)
        ready=1'b0;
end

endmodule
