#include "packet_transaction_util.h"
#include "packet_transaction.h"

/* This is only for current node */
/****************** Structure ******************/

struct Edge edge_p1_p2;

struct Edge edge_p2_p3;

struct Edge edges[2];
/****************** Structure ******************/

/* This is only for current node */
struct Edge* get_edge(uint8_t proc_num, uint8_t port_num, uint8_t inout)
{
    if (inout == 0  /*it is input edge*/) {


        if (proc_num == 2) {
            if (port_num == 0)
                return &edge_p1_p2;
        }
    }

    if (inout == 1  /*it is output edge*/) {


        if (proc_num == 2) {
            if (port_num == 0)
                return &edge_p2_p3;
        }
    }

    return 0;
}

/* This is only for current node */
ring_buffer_t* get_buffer(alt_u16 proc_src, alt_u16 proc_dest)
{
    for (int i = 0; i < 2; i++) {
        if (edges[i].proc_src == proc_src) {
            if (edges[i].proc_dest == proc_dest) {
                return edges[i].buffer;
            }
        }
    }
    return 0;
}

/* This is only for current node */
void init_buffer(){


	ring_buffer_t buff_p1_p2;
	ring_buffer_init(&buff_p1_p2);
}

/* This is only for current node */
void init_structures(){
	init_buffer();


	//Edge p1 to p2
	edge_p1_p2.node_src = 0;
	edge_p1_p2.node_dest = 1;
	edge_p1_p2.proc_src = 1;
	edge_p1_p2.proc_dest = 2;
	edge_p1_p2.num_of_inp_token = P2_INP0_NUM_OF_TOKEN;
	edge_p1_p2.size_of_token_type = sizeof(P2_INP0_TYPE);
	edge_p1_p2.external = 1;
	edge_p1_p2.buffer = &buff_p1_p2;
	edges[0] = edge_p1_p2;

	//Edge p2 to p3
	edge_p2_p3.node_src = 1;
	edge_p2_p3.node_dest = 3;
	edge_p2_p3.proc_src = 2;
	edge_p2_p3.proc_dest = 3;
	edge_p2_p3.num_of_out_token = P2_OUT0_NUM_OF_TOKEN;
	edge_p2_p3.size_of_token_type = sizeof(P2_OUT0_TYPE);
	edge_p2_p3.external = 1;
	edges[1] = edge_p2_p3;


}

void send_packet(unsigned char node_src, unsigned char node_dest,
alt_u16 proc_src, alt_u16 proc_dest, unsigned char packsize, unsigned char *payload){

    unsigned int temp;
    unsigned char src_high, src_low;

    src_low = proc_src;
    proc_src >>= 8;
    src_high = proc_src;


    temp = src_high<<24 | ((packsize)<<16) | ((node_src)<<8) | (node_dest);
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

    temp = node_src<<24 | proc_dest<<8 | src_low;
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

    temp = ((*(payload + 3))<<24) | ((*(payload + 2))<<16) | ((*(payload + 1))<<8) | (*payload);
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

    temp = ((*(payload + 7))<<24) | ((*(payload + 6))<<16) | ((*(payload + 5))<<8) | ((*(payload + 4)));
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

    temp = ((*(payload + 11))<<24) | ((*(payload + 10))<<16) | ((*(payload + 9))<<8) | ((*(payload + 8)));
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

    temp = ((*(payload + 15))<<24) | ((*(payload + 14))<<16) | ((*(payload + 13))<<8) | ((*(payload + 12)));
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

    temp = ((*(payload + 19))<<24) | ((*(payload + 18))<<16) | ((*(payload + 17))<<8) | ((*(payload + 16)));
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

    temp = ((*(payload + 23))<<24) | ((*(payload + 22))<<16) | ((*(payload + 21))<<8) | ((*(payload + 20)));
    altera_avalon_fifo_write_fifo(FIFO_SOURCE_BASE, FIFO_SOURCE_CSR, temp);

}

void read_payload(unsigned int temp, unsigned int byte_coef, unsigned char *payload){
	*(payload + 0 + byte_coef) = temp;
	//printf("payload[%d] = %d\n",byte_coef,*(payload + 0 + byte_coef));
	temp >>= 8;
	
	*(payload + 1 + byte_coef) = temp;
	//printf("payload[%d] = %d\n",(byte_coef + 1),*(payload + 1 + byte_coef));
	temp >>= 8;
	
	*(payload + 2 + byte_coef) = temp;
	//printf("payload[%d] = %d\n",(byte_coef + 2),*(payload + 2 + byte_coef));
	temp >>= 8;
	
	*(payload + 3 + byte_coef) = temp;
	//printf("payload[%d] = %d\n",(byte_coef + 3),*(payload + 3 + byte_coef));
}

void receive_packet(){
	
	unsigned int temp;
	unsigned char node_dest, node_src, packet_size;
	unsigned char src_high, src_low;
	unsigned char payload[24];

	alt_u16 dst_proc, src_proc;

	//first four bytes
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	node_dest = temp;
	//printf("node destination = %d\n",node_dest);
	temp >>= 8;

	node_src = temp;
	//printf("node source = %d\n",node_src);
	temp >>= 8;

	packet_size = temp;
	//printf("packet_size = %d\n",packet_size);
	temp >>= 8;

	src_high = temp;
	src_proc = src_high;
	src_proc <<= 8;


	//second four bytes are are for node number and source
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	src_low = temp;
	src_proc |= src_low;
	temp >>= 8;
	dst_proc = temp;
	//printf("source process = %d\n",src_proc);
	//printf("destination process = %d\n",dst_proc);


	//since now, recieve the payload

	//1st four bytes of payload 
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	read_payload(temp,0,payload);

	//2nd four bytes of payload 
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	read_payload(temp,4,payload);

	//3rd four bytes of payload 
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	read_payload(temp,8,payload);

	//4th four bytes of payload 
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	read_payload(temp,12,payload);

	//5th four bytes of payload 
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	read_payload(temp,16,payload);

	//6th four bytes of payload 
	temp = altera_avalon_fifo_read_fifo(FIFO_SINK_BASE, FIFO_SINK_CSR);
	read_payload(temp,20,payload);	

	//get bufer
	ring_buffer_t *buffer = get_buffer(src_proc, dst_proc);

	ring_buffer_queue_arr(buffer,payload,24);
}

bool receive_poll(){
	int status;
	status = altera_avalon_fifo_read_status(FIFO_SINK_CSR,FIFO_STATUS);
    /*while(status & 0x02){
    	usleep(5000000);
  	  status = altera_avalon_fifo_read_status(FIFO_SINK_CSR,FIFO_STATUS);
    }*/
	if(status & 0x02)
		return false;
	else
		return true;
}
