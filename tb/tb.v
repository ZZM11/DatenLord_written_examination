module tb();

reg clk;
reg rst_n;
reg busy;
reg ready;
reg valid;
reg [7:0] data_in;
wire [7:0] data_out;
always	#5	clk = ~clk;
//产生传输数据
always #15 data_in = data_in + 1'b1;

initial
	begin
		clk <= 1'b1;
		rst_n <= 1'b0;
        //busy信号控制接受端工作状态
		busy <= 1'b0;
		data_in <= 0;

		#20
		 rst_n <= 1'b1;
	end

master u_master(
           .clk ( clk ),
           .rst_n ( rst_n ),
           .ready ( ready ),
           .valid ( valid ),
           .data_in ( data_in ),
           .data_out ( data_out )
       );


salve u_salve(
          .clk ( clk ),
          .rst_n ( rst_n ),
          .valid ( valid ),
          .data_in_s ( data_out ),
          .ready ( ready ),
          .data_out_s ( data_out_s ),
          .busy ( busy )
      );



endmodule
