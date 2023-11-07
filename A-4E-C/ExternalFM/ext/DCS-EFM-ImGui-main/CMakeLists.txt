# CMAKELISTS.TXT|CREATED 23-JUN-2022|LAST MODIFIED 23-JUN-2022

cmake_minimum_required(VERSION 3.13)
set(CMAKE_CXX_STANDARD 11)
set(
	GLOBAL_SOURCES
	./Source/DllMain.cpp ./Source/FmGui.cpp
)
set(
	IMGUI_SOURCES 
	./Lib/imgui/imgui/imgui.cpp
	./Lib/imgui/imgui/imgui_demo.cpp
	./Lib/imgui/imgui/imgui_draw.cpp
	./Lib/imgui/imgui/imgui_impl_dx11.cpp
	./Lib/imgui/imgui/imgui_impl_win32.cpp
	./Lib/imgui/imgui/imgui_tables.cpp
	./Lib/imgui/imgui/imgui_widgets.cpp
)
set(
	IMPLOT_SOURCES
	./Lib/implot/implot.cpp
	./Lib/implot/implot_demo.cpp
	./Lib/implot/implot_items.cpp
)
project(FmGui)

# Global configuration.
link_directories(./Lib/MinHook/lib)
link_libraries(libMinHook.x64.lib)
# Both libraries need to be built with unicode support. As this is typically the
# default.
add_definitions(-D_UNICODE -DUNICODE)

# FmGui with excluded ImPlot.
add_library(FmGui STATIC
	${GLOBAL_SOURCES}
	${IMGUI_SOURCES}
)
target_include_directories(
	FmGui
	PRIVATE
	./Include
	./Lib/imgui/imgui
	./Lib/MinHook/include
)
target_link_options(FmGui PRIVATE "/SUBSYSTEM:WINDOWS")

# FmGui.ImPlot with ImPlot included.
add_library(FmGui.ImPlot STATIC
	${GLOBAL_SOURCES}
	${IMGUI_SOURCES}
	${IMPLOT_SOURCES}
)
target_include_directories(
	FmGui.ImPlot
	PRIVATE
	./Include
	./Lib/imgui/imgui
	./Lib/implot
	./Lib/MinHook/include
)
target_compile_definitions(FmGui.ImPlot PRIVATE FMGUI_ENABLE_IMPLOT)
target_link_options(FmGui.ImPlot PRIVATE "/SUBSYSTEM:WINDOWS")