cmake_minimum_required(VERSION 3.5)

project(udp LANGUAGES C)
set(CMAKE_C_STANDARD 11)

add_executable(udp main.c)
target_link_libraries(udp m)
