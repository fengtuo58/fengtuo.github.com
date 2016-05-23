########################################################################################

#

# Generic Makefile for C/C++ Program

#

# Author: mengk

# Date:   2008/08/30

#=======================================================================================

 

 

 

# 一 、 操作系统及shell相关

########################################################################################

#指定使用的shell及取得操作系统类型，宏定义常用shell命令

 

#指定SHELL ,SHELL := /bin/sh ,或者使用当前SHELL设置

#SHELL := /bin/bash

 

#取得操作系统名称#OS_NAME="Linux:SunOS:HP-UX:AIX"

OS_NAME := $(shell uname -s)

 

 

#把常用的几个系统命令自定义名称和选现,rm命令前面加了一个小减号的意思就是，

#也许某些文件出现问题，但不要管，继续做后面的事

 

AR := ar            

SED:= sed          

AWK:= awk

MV := mv

RM := rm -f

ECHO := echo

 

#=======================================================================================

 

 

# 二 、C编译器选项

########################################################################################

#指定C编译器, 如gcc  编译器

CC      := gcc

#指定C编译时的选项

#CFLAGS         C语言编译器参数,编译时使用。

CFLAGS := -c -g  -W -Wall

 

# CPP ,  C 预编译器的名称，默认值为 $(CC) -E。

CPP :=

#   CPPFLAGS , C 预编译的选项。

CPPFLAGS :=

 

 

# 三 、C++编译器选项

########################################################################################

#=======================================================================================

 

#指定C++编译器, 如g++ 编译器

CXX      := g++

 

#指定C编译时的选项

#CXXFLAGS         C++语言编译器参数,编译时使用。

CXXFLAGS := -c -g -W -Wall

 

# CXXPP ,  C++ 预编译器的名称，默认值为 $(CC) -E。

CXXPP :=

#   CXXPPFLAGS , C++ 预编译的选项。

CXXPPFLAGS :=

 

#=======================================================================================

 

 

# 四、指定额外搜索的头文件路径、库文件路径 、引入的库

########################################################################################

#指定搜索路径, 也可用include指定具体文件路径,编译时使用

# The include files ( C and C++ common).

INCLUDES := -I$(ORACLE_HOME)/rdbms/demo -I$(ORACLE_HOME)/rdbms/public  \

  -I$(ORACLE_HOME)/plsql/public -I$(ORACLE_HOME)/network/public  -I./include -I./include/app -I./include/tools  \

  -I./include/tools/file  -I./include/tools/common

 

# 指定函数库搜索路径DIRECTORY 搜寻库文件(*.a)的路径,加入需要的库搜索路径 功能同–l，由用户指定库的路径，否则编译器将只在标准库的目录找。           

#连接时使用

LIBDIRS :=-L$(ORACLE_HOME)/lib -L$(ORACLE_HOME)/rdbms/lib

 

# 链接器参数,  连接时搜索指定的函数库LDFLAGS。,引入需要的库-lLDFLAGS    指定编译的时候使用的库. 连接库文件开关。例如-lugl，则是把程序同libugl.a文件进行连接。

#连接时使用

#-lclntsh -lnsl -lpthread -Wl,-Bdynamic -lgcc_s    ,同时有动态库和静态库时默认使用动态库，   -Wl,-Bdynamic 指定和动态库相连， -Wl,-Bstatic 指定和静态库相连

CLDFLAGS    :=  -lm  -lclntsh -lnsl -lpthread  -Wl,-Bdynamic  -lgcc_s

CXXLDFLAGS  :=  -lm  -lclntsh -lnsl -lpthread  -Wl,-Bdynamic -lgcc_s  -lstdc++ 

 

#宏定义，如果没有定义宏的值，默认是字符串1 ,定义值为数字时直接写数字，字符和字符串需用 \"和\'转义

#DCPPFLAGS :=  -D${OS_NAME}   -D_TEST1_  -D_TEST2_=2  -D_TEST3_=\"a\"  -D_TEST4_=\'b\' -DOS_NAME=\"${OS_NAME}\"

DCPPFLAGS := -D${OS_NAME}   

 

#各平台'SunOS'   'Linux' link类库差异, 设置特定值

ifeq '${OS_NAME}' 'SunOS'

    CLDFLAGS += -lsocket

    CXXLDFLAGS += -lsocket

    DCPPFLAGS += -D_POSIX_PTHREAD_SEMANTICS -D_REENTRANT

endif

 

#=======================================================================================

 

 

#  五、 指定源文件的路径 、支持的源文件的扩展名 、源文件搜索路径

########################################################################################

# 指定SRC_DIR 源代码文件路径./src  ./src2   src2/src3

SRC_DIR   := .  ./src  ./src/copyfile  ./src/displayfile ./include/tools/file  ./include/tools/common

 

 

#指定支持的源代码扩展名 SFIX     := .out .a .ln  .o  .c  .cc .C  .p  .f  .F 

#.r  .y  .l  .s  .S  .mod  .sym  .def  .h  .info  .dvi  .tex  .texinfo  .texi 

#.txinfo  .w  .ch .web  .sh  .elc  .el

SFIX     :=  .c .C .cpp  .cc .CPP  .c++  .cp  .cxx

 

#在当当前目录找不到的情况下，到VPATH所指定的目录中去找寻文件了。如:VPATH = src:../headers

#（当然，当前目录永远是最高优先搜索的地方）

VPATH := ${SRC_DIR}

 

#定义安装目录            

BIN := ./bin

 

#=======================================================================================

 

 

#  六、 得到源文件名称集合、OBJS目标文件名集合

########################################################################################

 

#依次循环取得各目录下的所有源文件，在各目录下取源文件时过滤不支持的源文件格式，

#得到源文件集合(带路径)

SOURCES := $(foreach x,${SRC_DIR},\

           $(wildcard  \

             $(addprefix  ${x}/*,${SFIX}) ) )

 

#去掉路径信息，去掉扩展名，再追加.o的扩展名，得到目标文件名集合 (不带路径),需要去掉路径信息，否则连接时有可能找不到.o文件

OBJS := $(addsuffix .o ,$(basename $(notdir ${SOURCES}) ) )    

 

 

#去掉路径信息，去掉扩展名，再追加.d的扩展名，得到依赖文件名集合 (不带路径)

#DEPENDS := $(addsuffix .d ,$(basename $(notdir ${SOURCES}) ) )

 

#去掉扩展名，再追加.d的扩展名，得到依赖文件名集合 (带路径)

DEPENDS := $(addsuffix .d ,$(basename  ${SOURCES} ) )  

#DEPENDS := $(SOURCES:$(SFIX)=.d)

 

#=======================================================================================

 

 

#  七、 定义生成程序的名称

########################################################################################

 

#生成可执行程序的名称

PROGRAM   := example

 

#=======================================================================================

 

 

#  八、 定义依赖关系 ，编译、链接规则

########################################################################################

 

#.PHONY”表示，clean是个伪目标文件。

.PHONY : all check  clean  install

 

 

#定义编译、链接任务all

all :  ${PROGRAM}  install

 

#检查源码中，除了C源码外是否有C++源码 ,并定义变量LDCXX存储检查结果

LDCXX := $(strip $(filter-out  %.c , ${SOURCES} ) )

 

#编译器重置

ifdef LDCXX   #有C++源码时,所有源码都使用g++编译，包括C源码，将CC、CFLAGS 的值设置为对应的${CXX}、 ${CXXFLAGS}的值

    CC := ${CXX}                    #重置C编译器为C++编译器

    CFLAGS :=  ${CXXFLAGS}          #重置C编译选现为C++编译选现

    CPP :=  ${CXXPP}                #重置C预编译器为C++预编译器

    CPPFLAGS := ${CXXPPFLAGS}       #重置C预编译的选项为C++预编译的选项

endif

 

#链接

${PROGRAM} :  ${DEPENDS}  ${OBJS} 

ifeq ($(strip $(filter-out  %.c  , ${SOURCES} ) ),)    #只有C源码时使用gcc连接

    ${CC}  ${LIBDIRS}  ${CLDFLAGS}    ${OBJS} -o $@    

else                                                 #有C++源码时使用g++连接

    $(CXX) ${LIBDIRS}  ${CXXLDFLAGS}    ${OBJS} -o $@     

endif

 

# Rules for producing the objects. (.o) BEGIN

#---------------------------------------------------

 

%.o : %.c

    $(CC)      ${DCPPFLAGS}    ${CFLAGS}      ${INCLUDES}   $<

 

%.o : %.C

    $(CXX)     ${DCPPFLAGS}    ${CXXFLAGS}    ${INCLUDES}   $<

 

%.o : %.cc

    ${CXX}     ${DCPPFLAGS}    ${CXXFLAGS}    ${INCLUDES}   $<

 

%.o : %.cpp

    ${CXX}     ${DCPPFLAGS}    ${CXXFLAGS}    ${INCLUDES}   $<

 

%.o : %.CPP

    ${CXX}     ${DCPPFLAGS}    ${CXXFLAGS}    ${INCLUDES}   $<

 

%.o : %.c++

    ${CXX}     ${DCPPFLAGS}    ${CXXFLAGS}    ${INCLUDES}   $<

 

%.o : %.cp

    ${CXX}     ${DCPPFLAGS}    ${CXXFLAGS}    ${INCLUDES}   $<

 

%.o : %.cxx

    ${CXX}     ${DCPPFLAGS}    ${CXXFLAGS}    ${INCLUDES}   $<

 

#---------------------------------------------------

# Rules for producing the objects.(.o) END

 

 

# Rules for creating the dependency files (.d). BEGIN

#---------------------------------------------------

%.d : %.c

    @${CC}     -M   -MD    ${INCLUDES} $<

 

%.d : %.C

    @${CXX}    -MM  -MD    ${INCLUDES} $<

 

%.d : %.cc

    @${CXX}    -MM  -MD    ${INCLUDES} $<

 

%.d : %.cpp

    @${CXX}    -MM  -MD    ${INCLUDES} $<

 

%.d : %.CPP

    @${CXX}    -MM  -MD    ${INCLUDES} $<

 

%.d : %.c++

    @${CXX}    -MM  -MD    ${INCLUDES} $<

 

%.d : %.cp

    @${CXX}    -MM  -MD    ${INCLUDES} $<

 

%.d : %.cxx

    @${CXX}    -MM  -MD    ${INCLUDES} $<

 

#---------------------------------------------------

# Rules for creating the dependency files (.d). END

 

 

#=======================================================================================

 

 

#  九、 定义其他 check  install clean 等任务

########################################################################################

 

#定义检查环境相关的变量的任务

check :

    @${ECHO}  MAKEFILES : ${MAKEFILES}

    @${ECHO}  MAKECMDGOALS : ${MAKECMDGOALS}

    @${ECHO}  SHELL  : ${SHELL}

    @${ECHO}  OS_NAME  : ${OS_NAME}

    @${ECHO}  SRC_DIR : ${SRC_DIR}

    @${ECHO}  SFIX : ${SFIX}

    @${ECHO}  VPATH : ${VPATH}

    @${ECHO}  BIN : ${BIN}

    @${ECHO}  SOURCES : ${SOURCES}

    @${ECHO}  OBJS : ${OBJS}

    @${ECHO}  DEPENDS : ${DEPENDS}

    @${ECHO}  PROGRAM : ${PROGRAM}

    @${ECHO}  CC :  ${CC}

    @${ECHO}  CFLAGS : ${CFLAGS}

    @${ECHO}  CPP : ${CPP}

    @${ECHO}  CPPFLAGS : ${CPPFLAGS}

    @${ECHO}  CXX :  ${CXX}

    @${ECHO}  CXXFLAGS : ${CXXFLAGS}

    @${ECHO}  CXXPP : ${CXXPP}

    @${ECHO}  CXXPPFLAGS : ${CXXPPFLAGS}       

    @${ECHO}  INCLUDES : ${INCLUDES}

    @${ECHO}  LIBDIRS : ${LIBDIRS}

    @${ECHO}  CLDFLAGS : ${CLDFLAGS}

    @${ECHO}  CXXLDFLAGS : ${CXXLDFLAGS}

    @${ECHO}  DCPPFLAGS : ${DCPPFLAGS}

    uname    -a

 

#定义清理的任务 core.*  ,rm命令前面加了一个小减号的意思就是， 也许某些文件出现问题，但不要管，继续做后面的事

clean :

    -${RM} ${BIN}/${PROGRAM}

    -${RM} ${BIN}/*.o

    -${RM} ${BIN}/*.d

    -${RM} *.o

    -${RM} *.d

 

#将目标文件及可执行程序拷贝到安装目录

install :

    -${MV} ${PROGRAM} ${BIN}

    -${MV}  *.o ${BIN}

    -${MV}  *.d ${BIN}

 

 

#========
