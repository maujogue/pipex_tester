#!/bin/bash
if [ $1 = "clean" ]; then
rm -rf tests_result
else
make
rm -rf tests_result
mkdir tests_result
cp pipex tests_result
cp Makefile tests_result/infile.txt
cd tests_result

VAR1="$1"
RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[0;37m'
CYAN='\033[0;36m'
BPURPLE='\033[1;35m' 

if [ "$2" = "no_sleep" ] || [ "$3" = "no_sleep" ]; then
{
    SLEEP=""
}
else
    SLEEP="sleep 1"
fi
#############################################################

if [ "$VAR1" = "1" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n1 : Functional commands :\n"

./pipex infile.txt ls "wc -l" out_wc
./pipex infile.txt ls "sleep 1" out_empty
./pipex infile.txt "cat /dev/random" "head -n 5" out_random
echo -e "${BPURPLE}Done.${WHITE}"
fi


if ([ "$VAR1" = "valgrind" ] && [ "$2" = "" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "1" ]); then
echo -e "${WHITE}"
valgrind ./pipex infile.txt ls "wc -l" out_wc
${SLEEP}
valgrind ./pipex infile.txt ls "sleep 1" out_empty
${SLEEP}
valgrind ./pipex infile.txt "cat /dev/random" "head -n 5" out_raccndom
${SLEEP}
fi

#############################################################

if [ "$VAR1" = "2" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n2 : Empty commands :"

echo -e "${WHITE}\nExpected : ${GREEN}both commands are not valid\n${WHITE}Result : ${RED}"
./pipex infile.txt "  " "/usr/bin  /  ls"  out_1
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}First command is not valid \n${WHITE}Result : ${RED}"
./pipex infile.txt "  ls" "cat"  out_1.5
${SLEEP}
echo -e "${WHITE}\n\nExpected : ${GREEN}both commands are not valid\n${WHITE}Result : ${RED}"
./pipex infile.txt "" "" out_2
${SLEEP}
echo -e "${WHITE}\n\nExpected : ${GREEN}First command is not valid\n${WHITE}Result : ${RED}"
./pipex infile.txt "" "ls" out_3_ls
${SLEEP}
echo -e "${WHITE}\n\nExpected : ${GREEN}Second command is not valid\n${WHITE}Result : ${RED}"
./pipex infile.txt "ls" "" out_4
${SLEEP}
fi

if ([ "$VAR1" = "valgrind" ] && [ "$2" = "" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "2" ]); then
echo -e "${WHITE}"
valgrind ./pipex infile.txt "  " "/usr/bin  /  ls"  out_1
${SLEEP}
valgrind ./pipex infile.txt "  ls" "cat"  out_1.5
${SLEEP}
valgrind ./pipex infile.txt "" "" out_2
${SLEEP}
valgrind ./pipex infile.txt "" "ls" out_3_ls
${SLEEP}
valgrind ./pipex infile.txt "ls" "" out_4
${SLEEP}
fi

#############################################################

if [ "$VAR1" = "3" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n\n3 : Commands are full paths\n"

echo -e "${WHITE}\nExpected : ${GREEN}1 second sleep\n${WHITE}Result : ${RED}"
./pipex infile.txt "ls" "/usr/bin/sleep 1" out_5
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}1 second sleep + ls in out_6 file\n${WHITE}Result : ${RED}"
./pipex infile.txt "/usr/bin/sleep 1" "ls" out_6_ls
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}ls | grep e in out_7 file\n${WHITE}Result : ${RED}"
./pipex infile.txt "/usr/bin/ls" "/usr/bin/grep e " out_7_grep_e
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}Second command is not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "/usr/bin/ls" "" out_8
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}First command is not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "" "/usr/bin/ls"  out_9_ls
${SLEEP}
fi

if ([ "$VAR1" = "valgrind" ] && [ "$2" = "" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "3" ]); then
echo -e "${WHITE}"
valgrind ./pipex infile.txt "ls" "/usr/bin/sleep 1" out_5
${SLEEP}
valgrind ./pipex infile.txt "/usr/bin/sleep 1" ls  out_6_ls
${SLEEP}
valgrind ./pipex infile.txt "/usr/bin/ls" "/usr/bin/grep e" out_7_grep_e
${SLEEP}
valgrind ./pipex infile.txt "/usr/bin/ls" "" out_8
${SLEEP}
valgrind ./pipex infile.txt "" "/usr/bin/ls"  out_9_ls
${SLEEP}
fi

#############################################################

if [ "$VAR1" = "4" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n\n4 : Commands are errors\n"

echo -e "${WHITE}\nExpected : ${GREEN}First command is not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "lss" "wc -l" out_10_wc_l
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}Second command is not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "ls" "wcc -l" out_11
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}Both commands are not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "lss" "wcc -l" out_12
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}First command is not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "./ls" "wc -l" out_13_wc_l
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}Second command is not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "ls" "/" out_14
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}Both commands are not valid\n${WHITE}Result : ${RED} "
./pipex infile.txt "/usr/bin /ls" "/usr/bin/ wc -l" out_15
${SLEEP}
fi

if ([ "$VAR1" = "valgrind" ] && [ "$2" = "" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "4" ]) ; then
echo -e "${WHITE}"
valgrind ./pipex infile.txt "lss" "wc -l" out_10_wc_l
${SLEEP}
valgrind ./pipex infile.txt "ls" "wcc -l" out_11
${SLEEP}
valgrind ./pipex infile.txt "lss" "wcc -l" out_12
${SLEEP}
valgrind ./pipex infile.txt "./ls" "wc -l" out_13_wc_l
${SLEEP}
valgrind ./pipex infile.txt "ls" "/" out_14
${SLEEP}
valgrind ./pipex infile.txt "/usr/bin /ls" "/usr/bin/ wc -l" out_15
fi
#############################################################

if [ "$VAR1" = "5" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n\n5 : Infile is not defined\n"

echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory\n${WHITE}Result : ${RED} ${RED}"
./pipex inexistant "sleep 1" "/usr/bin/ls"  out_16_ls
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory\n${WHITE}Result : ${RED} "
./pipex inexistant "ls" "/usr/bin/cat"  out_17
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory\n${WHITE}Result : ${RED} "
./pipex inexistant "ls" "cat"  out_18
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory\n${WHITE}Result : ${RED} "
./pipex inexistant "" "/usr/bin/pwd"  out_19_pwd
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory twice\n${WHITE}Result : ${RED} "
./pipex inexistant "" ""  out_20
${SLEEP}
fi

if ([ "$VAR1" = "valgrind" ] && [ "$2" = "all" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "5" ]); then
echo -e "${WHITE}"
valgrind ./pipex inexistant "sleep 1" "/usr/bin/ls"  out_16_ls
${SLEEP}
valgrind ./pipex inexistant "ls" "/usr/bin/cat"  out_17
${SLEEP}
valgrind ./pipex inexistant "ls" "cat"  out_18
${SLEEP}
valgrind ./pipex inexistant "" "/usr/bin/pwd"  out_19_pwd
${SLEEP}
valgrind ./pipex inexistant "" ""  out_20
${SLEEP}
fi

#############################################################

if [ "$VAR1" = "6" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n\n6 : File without permission\n"

echo -e "${WHITE}\nExpected : ${GREEN}Permission denied\n${WHITE}Result : ${RED} "
touch test
chmod 000 test
./pipex test "ls" "cat"  out_21
${SLEEP}

echo -e "${WHITE}\nExpected : ${GREEN}Permission denied + sleep 1\n${WHITE}Result : ${RED} "
./pipex test "ls" "sleep 1"  out_22
${SLEEP}

echo -e "${WHITE}\nExpected : ${GREEN}Permission denied + ls in out_23 \n${WHITE}Result : ${RED} "
./pipex test "ls" "ls"  out_23_ls
${SLEEP}
fi

if ([ "$VAR1" = "valgrind" ] && [ "$2" = "" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "6" ]); then
echo -e "${WHITE}"
valgrind ./pipex test "ls" "cat"  out_21
${SLEEP}
valgrind ./pipex test "ls" "sleep 1"  out_22
${SLEEP}
valgrind ./pipex test "ls" "ls"  out_23_ls
${SLEEP}

fi
#############################################################

if [ "$VAR1" = "7" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n7 : Same infile and outfile without permissions\n"

echo -e "${WHITE}\nExpected : ${GREEN}Permission denied twice\n${WHITE}Result : ${RED} "
./pipex test "ls" "cat"  test
${SLEEP}
fi

if ([ "$VAR1" = "valgrind" ] && [ "$2" = "" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "7" ]); then
echo -e "${WHITE}"
valgrind ./pipex test "ls" "cat"  test
${SLEEP}
fi
#############################################################

if [ "$VAR1" = "8" ] || [ "$VAR1" = "all" ]; then
echo -e "${CYAN}\n8 : PATH undefined\n"

echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory twice\n${WHITE}Result : ${RED} "
env -i ./pipex infile.txt "pwd"  "ls" out_24
${SLEEP}

echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory\n${WHITE}Result : ${RED} "
env -i ./pipex infile.txt "pwd"  "/usr/bin/ls" out_25_ls
${SLEEP}

echo -e "${WHITE}\nExpected : ${GREEN}No such file or directory\n${WHITE}Result : ${RED} "
env -i ./pipex inexistant "" "/usr/bin/pwd"  out_26_pwd
${SLEEP}
echo -e "${WHITE}\nExpected : ${GREEN}Permission denied twice\n${WHITE}Result : ${RED} "
unset PATH
./pipex test "ls" "cat"  test
fi

if ([ "$VAR1" = "valgrind" ] && [ "$2" = "" ]) || ([ "$VAR1" = "valgrind" ] && [ "$2" = "8" ]); then
valgrind env -i ./pipex infile.txt "pwd"  "ls" out_24
${SLEEP}
valgrind env -i ./pipex infile.txt "pwd"  "/usr/bin/ls" out_25_ls
${SLEEP}
valgrind env -i ./pipex inexistant "" "/usr/bin/pwd"  out_26_pwd
${SLEEP}
fi

echo -e "\n${BPURPLE}Finished.${WHITE}"
fi