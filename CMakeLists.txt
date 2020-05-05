cmake_minimum_required(VERSION 3.7)

#The-Forge demo
project(ForgeDemo)

#The-Forge dir
set(DEMO_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# C++14 - need c++14 to keep eastl happy
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(WIN32)
	option(VULKAN "Enable Vulkan render" ON)
	option(D3D12 "Enable D3D12 render" OFF)
else()
	option(VULKAN "Enable Vulkan render" ON)
endif()

#we can't have multiple renderers at once
if(WIN32)
	if(VULKAN AND D3D12)
	message(FATAL_ERROR "Please select either Vulkan or D3D12, not both.")
	endif()
endif()

#external libs
#glfw
add_subdirectory("${DEMO_DIR}/external/glfw")

#the-forge
add_subdirectory("${DEMO_DIR}/external/the-forge")

#Demo source
file(GLOB DEMO_SRC "${DEMO_DIR}/src/*.*")

#the-forge implementation files
if(WIN32)
	file(GLOB FORGEIMPL_SRC "${DEMO_DIR}/src/interfaces/windows/*.*")
else()
	file(GLOB FORGEIMPL_SRC "${DEMO_DIR}/src/interfaces/linux/*.*")
endif()

#includes
set(DEMO_INCLUDES
	${DEMO_DIR}/src
	${DEMO_DIR}/external/stb
	${DEMO_DIR}/external/glfw/include
	${DEMO_DIR}/external/glm
	${DEMO_DIR}/external/the-forge/src
	${DEMO_DIR}/external/the-forge/Common_3/
	${DEMO_DIR}/external/the-forge/Common_3/ThirdParty
)

#Libs - all platforms
set(DEMO_LIBS glfw the-forge)
#Libs - apple
if(WIN32)
	set(DEMO_LIBS ${DEMO_LIBS} Winmm.lib)
endif()

#Gfx libs/includes
if (VULKAN)
	set(DEMO_INCLUDES ${DEMO_INCLUDES} ${Vulkan_INCLUDE_DIRS})
endif()

#D3D12 libs/includes
if(D3D12)
   set(DEMO_LIBS ${DEMO_LIBS} ${DEMO_DIR}/external/the-forge/Common_3/ThirdParty/OpenSource/winpixeventruntime/bin/WinPixEventRuntime.lib)
endif()

#set all source code
set(DEMO_SRC ${DEMO_SRC} ${FORGEIMPL_SRC})

#Executable
if(WIN32)
	add_executable(ForgeDemo WIN32 ${DEMO_SRC})
else()
	add_executable(ForgeDemo ${DEMO_SRC})
endif()

target_link_libraries(ForgeDemo ${DEMO_LIBS})
target_include_directories(ForgeDemo PUBLIC ${DEMO_INCLUDES})

if(WIN32)
	target_compile_definitions(ForgeDemo PUBLIC GLFW_EXPOSE_NATIVE_WIN32)
	#eastl from the-forge needs this enabled
   set_target_properties(ForgeDemo PROPERTIES COMPILE_FLAGS "/Zc:wchar_t")
else()
	target_compile_definitions(ForgeDemo PUBLIC GLFW_EXPOSE_NATIVE_X11)
	set(CMAKE_CODELITE_USE_TARGETS ON)
endif()

#d3d12 defines
if(D3D12)
	target_compile_definitions(ForgeDemo PUBLIC DIRECT3D12)	
endif()

#vulkan defines
if (VULKAN)
	#this is a bit hacky, the-forge uses a pragma lib directive for vulkan , need to make sure it will find it
	if(WIN32)
		target_link_directories(ForgeDemo PRIVATE $ENV{VULKAN_SDK}/lib)
	endif()
	target_compile_definitions(ForgeDemo PUBLIC VULKAN)
endif()

# common the-forge defines, rest are all platform/api specific and are scattered above
target_compile_definitions(ForgeDemo PUBLIC USE_LOGGING)

#Target properties
#single config
set_target_properties(ForgeDemo PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${DEMO_DIR}/bin")
#multi-config
foreach( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES} )
	string( TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG )
	set_target_properties(ForgeDemo PROPERTIES RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${DEMO_DIR}/bin")
endforeach( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )

set_target_properties(ForgeDemo PROPERTIES DEBUG_POSTFIX "_debug")

#these are already set by default with visual studio
target_compile_definitions(ForgeDemo PUBLIC $<$<CONFIG:Debug>:_DEBUG>)
target_compile_definitions(ForgeDemo PUBLIC $<$<CONFIG:Debug>:USE_MEMORY_TRACKING>)

#Project solution folders
source_group("Demo" REGULAR_EXPRESSION ${DEMO_DIR}/src/.*)
if(WIN32)
	source_group("Interfaces\\Windows" REGULAR_EXPRESSION ${DEMO_DIR}/src/interfaces/windows/.*)
else()
	source_group("Interfaces\\Linux" REGULAR_EXPRESSION ${DEMO_DIR}/src/interfaces/linux/.*)
endif()

# Set Visual Studio startup project
if(MSVC)
   set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ForgeDemo)
endif()
