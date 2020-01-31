# Define user definitions

PROJECT_NAME=node_2
SAMPLE_TYPE=hello_world_small
SOPCINFO_DIR=./../quartus
SOPCINFO_FILE=qsys_system.sopcinfo
CPU_NAME=nios2_2
# Define internal symbols
BSP_STR=_bsp
APP_NAME=$PROJECT_NAME
BSP_NAME=$PROJECT_NAME$BSP_STR
APP_DIR=$SOPCINFO_DIR/software/$APP_NAME
BSP_DIR=$SOPCINFO_DIR/software/$BSP_NAME
# Create create-this-app and create-this-bsp script
nios2-swexample-create --name=$PROJECT_NAME \
--type=$SAMPLE_TYPE \
--sopc-file=$SOPCINFO_DIR/$SOPCINFO_FILE \
--app-dir=$APP_DIR \
--bsp-dir=$BSP_DIR \
--cpu-name=$CPU_NAME

# Build Application and BSP
cd $APP_DIR
./create-this-app

cd ../$BSP_NAME
./create-this-bsp

# Add source file and remove default one
cd ../$APP_NAME
rm hello_world_small.c
rm $PROJECT_NAME.elf
rm $PROJECT_NAME.map
rm $PROJECT_NAME.objdump
rm obj/default/hello_world_small.d
rm obj/default/hello_world_small.o
cp ../../../sw_sources/node_2 node_2
cp ../../../packet_transaction_lib/inc/header_2/packet_transaction_util.h packet_transaction_util.h
cp ../../../packet_transaction_lib/inc/packet_transaction.h packet_transaction.h
cp ../../../packet_transaction_lib/src/src_2/packet_transaction_util.c packet_transaction_util.c
cp ../../../packet_transaction_lib/buffer/* .

# generate make file for new source file
nios2-app-generate-makefile --bsp-dir=../$BSP_NAME \
--src-files=node_2
make

# build again
./create-this-app
