#include "altera_avalon_fifo_regs.h"
#include "altera_avalon_fifo_util.h"
#include "system.h"
#include <stdlib.h>
#include <stdbool.h>
#include "ringbuffer_util.h"

#define FIFO_SINK_CSR		FIFO_SINK_3_IN_CSR_BASE
#define FIFO_SOURCE_CSR		FIFO_SOURCE_3_IN_CSR_BASE
#define FIFO_SINK_BASE		FIFO_SINK_3_OUT_BASE
#define FIFO_SOURCE_BASE		FIFO_SOURCE_3_IN_BASE
#define FIFO_STATUS		ALTERA_AVALON_FIFO_STATUS_ALL


//proc 3
#define P3_NUM_OF_INPS 2
#define P3_NUM_OF_OUTS 1
#define P3_INP0_NUM_OF_TOKEN 1 
#define P3_INP0_TYPE int 
#define P3_INP1_NUM_OF_TOKEN 1 
#define P3_INP1_TYPE int 
#define P3_OUT0_NUM_OF_TOKEN 1 
#define P3_OUT0_TYPE int 



#define BUFFER_SIZE 50

/******************** BUFFER *********************/
ring_buffer_t buff_p2_p3;
ring_buffer_t buff_p1_p3;
/******************** BUFFER *********************/

/******************* Structure *******************/
struct Edge{
	uint8_t node_src;
	uint8_t node_dest;
	alt_u16 proc_src;
	alt_u16 proc_dest;
	uint8_t num_of_inp_token;
	uint8_t num_of_out_token;
	uint8_t size_of_token_type;
	ring_buffer_t *buffer;
	bool external;
};
/******************* Structure *******************/

struct Edge* get_edge(uint8_t proc_num, uint8_t port_num, uint8_t inout);

ring_buffer_t* get_buffer(alt_u16 proc_src, alt_u16 proc_dest);

void init_buffer();

void init_structures();

void send_packet(unsigned char node_src, unsigned char node_dest,
alt_u16 proc_src, alt_u16 proc_dest, unsigned char packsize, unsigned char *payload);

void receive_packet();

bool receive_poll();
