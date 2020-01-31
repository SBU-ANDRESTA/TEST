volatile int input_fifo_wrclk_irq_event;

#for @port in @ports:
P@{port.process_name}_@{port.direction}@{port.ID}_TYPE* proc_@{port.process_name}_@{port.direction_lowercase}_@{port.ID};
#end

#for @port in @ports:
void* proc_@{port.process_name}_@{port.direction_lowercase}arg_@{port.ID}[P@{port.process_name}_@{port.direction}@{port.ID}_NUM_OF_TOKEN];
#end

#for @process in @nodePR:
void** proc_@{process.process_name}_inps[P@{process.process_name}_NUM_OF_INPS];
void** proc_@{process.process_name}_outs[P@{process.process_name}_NUM_OF_OUTS];
#end

#for @process in @nodePR:
void proc_@{process.process_name}(void ***inpargs, void ***outargs){
#for @port in @ports:
#if(@port.process_name == @process.process_name)
	P@{port.process_name}_@{port.direction}@{port.ID}_TYPE* @{port.direction_lowercase}@{port.ID} = (P@{port.process_name}_@{port.direction}@{port.ID}_TYPE*) @{port.direction_lowercase}args[@{port.ID}];
#end
#end


	//functionality of code starts from here:
#include( "proc_@{process.process_name}.c" )
}
#end

static int init_input_fifo_wrclk_control(alt_u32 control_base_address)
{
  int return_code = ALTERA_AVALON_FIFO_OK;
  return_code = altera_avalon_fifo_init(control_base_address,
                                          0, // Disabled interrupts
                                          ALMOST_EMPTY,
                                          ALMOST_FULL);
  return return_code;
}

void print_status(alt_u32 control_base_address)

{
  printf("--------------------------------------\n");
  printf("LEVEL = %u\n", altera_avalon_fifo_read_level(control_base_address) );
  printf("STATUS = %u\n", altera_avalon_fifo_read_status(control_base_address,
    ALTERA_AVALON_FIFO_STATUS_ALL) );
  printf("EVENT = %u\n", altera_avalon_fifo_read_event(control_base_address,
    ALTERA_AVALON_FIFO_EVENT_ALL) );
  printf("IENABLE = %u\n", altera_avalon_fifo_read_ienable(control_base_address,
    ALTERA_AVALON_FIFO_IENABLE_ALL) );
  printf("ALMOSTEMPTY = %u\n",
    altera_avalon_fifo_read_almostempty(control_base_address) );
  printf("ALMOSTFULL = %u\n\n",
    altera_avalon_fifo_read_almostfull(control_base_address));
}


void read_buff(struct Edge *edge, alt_u16 proc_num, uint8_t input_num){

#for @port in @ports:
#if (@port.direction == 'INP')
	if(proc_num == @{port.process_name}){
		if(input_num == @{port.ID}){
			uint8_t tmp[edge->size_of_token_type];
			for(int i =0; i < edge->num_of_inp_token; ++i){
				ring_buffer_dequeue_arr(edge->buffer,tmp,edge->size_of_token_type);
				ring_buffer_pop_arr(edge->buffer,(24 - edge->size_of_token_type));
				proc_@{port.process_name}_inp_@{port.ID}[i] = ( (P@{port.process_name}_INP@{port.ID}_TYPE*)tmp )[0];
			}
		}
	}
#end
#end
}

void read_data(struct Edge *edge, alt_u16 proc_num, uint8_t input_num){

	while(ring_buffer_num_items((edge->buffer)) < (edge->num_of_inp_token * 24)){
		if(receive_poll())
			receive_packet();
	}
	read_buff(edge, proc_num, input_num);
}

void serializing_send(struct Edge *edge, unsigned char *array){
	unsigned char send_array[24];

	for(int i = 0; i < edge->size_of_token_type; ++i){
		send_array[i] = array[i];
	}

	if(edge->external == 1){
		send_packet(edge->node_src, edge->node_dest, edge->proc_src, edge->proc_dest, 32, send_array);
	}
	else{
		ring_buffer_queue_arr(edge->buffer,send_array,24);
	}
	//alt_printf("processor number %x sends data to %x ,which is %x\n",edge->proc_src,edge->proc_dest,( (int*)send_array )[0]);
	test_arr[counter] = ( (int*)send_array )[0];
}

void send_data(struct Edge *edge, alt_u16 proc_num, uint8_t output_num){
#for @port in @ports:
#if (@port.direction == 'OUT')
	if(proc_num == @{port.process_name}){
		if(output_num == @{port.ID}){
			for(int i =0; i < edge->num_of_out_token; ++i){
				serializing_send(edge, ((unsigned char*)proc_@{port.process_name}_outarg_@{port.ID}[i]));
			}
		}
	}
#end
#end
}

void proc_args_init(){
	// space allocation for input and output
#for @port in @ports:
	proc_@{port.process_name}_@{port.direction_lowercase}_@{port.ID} = (P@{port.process_name}_@{port.direction}@{port.ID}_TYPE*)malloc(P@{port.process_name}_@{port.direction}@{port.ID}_NUM_OF_TOKEN*sizeof(P@{port.process_name}_@{port.direction}@{port.ID}_TYPE));
#end

	// pointers to elements
#for @port in @ports:
	for(int i = 0; i < P@{port.process_name}_@{port.direction}@{port.ID}_NUM_OF_TOKEN; i++)
		proc_@{port.process_name}_@{port.direction_lowercase}arg_@{port.ID}[i] = &proc_@{port.process_name}_@{port.direction_lowercase}_@{port.ID}[i];
#end

	// top level pointers to be passed for proc 0
#for @port in @ports:
    proc_@{port.process_name}_@{port.direction_lowercase}[@{port.ID}] = proc_@{port.process_name}_@{port.direction_lowercase}arg_@{port.ID};
#end

#for @port in @ports:
#if (@port.initial_val)
#for @init_val in @port.initial_val:
	unsigned char temp[24];
	((P@{port.process_name}_@{port.direction}@{port.ID}_TYPE*)temp)[@{init_val.index}] = @{init_val.value};
	ring_buffer_queue_arr(&buff_@{port.name},temp,24);
#end
#end
#end


}

void cleanUp(){
#for @port in @ports:
	free(proc_@{port.process_name}_@{port.direction_lowercase}_@{port.ID});
#end
}

void start_FIFO(){
	//alt_putstr("Hello from Nios II!\n");

	//initialization of FIFOs
	init_input_fifo_wrclk_control(FIFO_SINK_0_IN_CSR_BASE);
	init_input_fifo_wrclk_control(FIFO_SOURCE_0_IN_CSR_BASE);

	//alt_putstr("source status:\n");
	//print_status(FIFO_SOURCE_0_IN_CSR_BASE);

	//alt_putstr("sink status:\n");
	//print_status(FIFO_SINK_0_IN_CSR_BASE);
}

int main()
{

	start_FIFO();
	proc_args_init();
	init_structures();


	//felan while true bokonam
	while(true){
#for @process in @nodePR:
		for(int i = 0; i < P@{process.process_name}_NUM_OF_INPS; i++){
		struct Edge *edge = get_edge(@{process.process_name},i,0);
		read_data(edge,@{process.process_name},i);
		}
		proc_@{process.process_name}(proc_@{process.process_name}_inps, proc_@{process.process_name}_outs);
		for(int i = 0; i <P@{process.process_name}_NUM_OF_OUTS; i++){
		struct Edge *edge = get_edge(@{process.process_name},i,1);
		send_data(edge,@{process.process_name},i);
		}
#end
	}
	cleanUp();

	while(1);

	return 0;
}
