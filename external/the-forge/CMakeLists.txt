cmake_minimum_required(VERSION 3.7)

project(the-forge)

set(FORGE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

message(${CMAKE_CURRENT_SOURCE_DIR})

#OS
file(GLOB FORGE_OS_INTERFACES "${FORGE_DIR}/Common_3/OS/Interfaces/*.*")
file(GLOB FORGE_OS_CORE "${FORGE_DIR}/Common_3/OS/Core/*.*")
file(GLOB FORGE_OS_IMAGE "${FORGE_DIR}/Common_3/OS/Image/*.*")
file(GLOB FORGE_OS_LOGGING "${FORGE_DIR}/Common_3/OS/Logging/*.*")
file(GLOB FORGE_OS_MATH "${FORGE_DIR}/Common_3/OS/Math/*.*")
file(GLOB FORGE_OS_MEMORYTRACKING "${FORGE_DIR}/Common_3/OS/MemoryTracking/*.*")
file(GLOB FORGE_OS_PROFILER "${FORGE_DIR}/Common_3/OS/Profiler/*.*")

#OS filesystem
set(FORGE_OS_FILESYSTEM
	${FORGE_DIR}/Common_3/OS/FileSystem/FileSystem.cpp	
	${FORGE_DIR}/Common_3/OS/FileSystem/SystemRun.cpp
	${FORGE_DIR}/Common_3/OS/FileSystem/ZipFileSystem.cpp
)

if(UNIX AND NOT APPLE)
	set(FORGE_OS_FILESYSTEM ${FORGE_OS_FILESYSTEM} ${FORGE_DIR}/Common_3/OS/FileSystem/UnixFileSystem.cpp)
endif()

#Renderer
set(FORGE_RENDERER
	${FORGE_DIR}/Common_3/Renderer/IRenderer.h
	${FORGE_DIR}/Common_3/Renderer/IResourceLoader.h
	${FORGE_DIR}/Common_3/Renderer/IShaderReflection.h
	${FORGE_DIR}/Common_3/Renderer/IRay.h
	${FORGE_DIR}/Common_3/Renderer/CommonShaderReflection.cpp
	${FORGE_DIR}/Common_3/Renderer/ResourceLoader.cpp
)

#eastl
set(FORGE_EASTL
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/EAStdC/EASprintf.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/EAStdC/EAMemory.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/thread_support.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/string.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/red_black_tree.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/numeric_limits.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/intrusive_list.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/hashtable.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/fixed_pool.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/assert.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/allocator_forge.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/allocator_eastl.cpp
)

#basis transcoder
file(GLOB FORGE_BASIS_TRANSCODER "${FORGE_DIR}/Common_3/ThirdParty/OpenSource/basis_universal/transcoder/*.*")

#zip
file(GLOB FORGE_ZIP "${FORGE_DIR}/Common_3/ThirdParty/OpenSource/zip/*.*")

#spirv tools
set(FORGE_SPIRVTOOLS 
	${FORGE_DIR}/Common_3/Tools/SpirvTools/SpirvTools.h
	${FORGE_DIR}/Common_3/Tools/SpirvTools/SpirvTools.cpp
)

#spirv-cross
file(GLOB FORGE_SPIRVCROSS "${FORGE_DIR}/Common_3/ThirdParty/OpenSource/SPIRV_Cross/*.*")

#rmem
set(FORGE_RMEM
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/rmem/src/rmem_get_module_info.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/rmem/src/rmem_hook.cpp
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource/rmem/src/rmem_lib.cpp
)

#lua lib
file(GLOB FORGE_LUA "${FORGE_DIR}/Common_3/ThirdParty/OpenSource/lua-5.3.5/src/*.*")
#remove luac.c
list(REMOVE_ITEM FORGE_LUA "${FORGE_DIR}/Common_3/ThirdParty/OpenSource/lua-5.3.5/src/luac.c")

#lua middleware
file(GLOB FORGE_LUA_MIDDLEWARE "${FORGE_DIR}/Middleware_3/LUA/*.*")

#UI middleware
set(FORGE_UI 
	${FORGE_DIR}/Middleware_3/UI/AppUI.h
	${FORGE_DIR}/Middleware_3/UI/AppUI.cpp
	${FORGE_DIR}/Middleware_3/UI/ImguiGUIDriver.cpp
)

file(GLOB FORGE_TEXT "${FORGE_DIR}/Middleware_3/Text/*.*")
file(GLOB FORGE_UI_IMGUI "${FORGE_DIR}/Common_3/ThirdParty/OpenSource/imgui/*.*")

if(D3D12)
	set(FORGE_DEFS ${FORGE_DEFS} DIRECT3D12)
	file(GLOB FORGE_RENDERER_D3D12 "${FORGE_DIR}/Common_3/Renderer/Direct3D12/*.*")
	set(FORGE_RENDERER ${FORGE_RENDERER} ${FORGE_RENDERER_D3D12})	
endif()

if(VULKAN)
   find_package(Vulkan REQUIRED)
	set(FORGE_DEFS ${FORGE_DEFS} VULKAN)
	set(FORGE_INCLUDES ${FORGE_INCLUDES} ${Vulkan_INCLUDE_DIRS})
	file(GLOB FORGE_RENDERER_VK "${FORGE_DIR}/Common_3/Renderer/Vulkan/*.*")
	set(FORGE_RENDERER ${FORGE_RENDERER} ${FORGE_RENDERER_VK})
endif()

#includes
set(FORGE_INCLUDES ${FORGE_INCLUDES} 
	${FORGE_DIR}
	${FORGE_DIR}/Common_3/OS
	${FORGE_DIR}/Common_3/ThirdParty/OpenSource
)

#definitions
set(FORGE_DEFS ${FORGE_DEFS} USE_LOGGING )

set(SOURCE_LIST ${FORGE_OS_INTERFACES} ${FORGE_OS_CORE} ${FORGE_OS_FILESYSTEM} ${FORGE_OS_IMAGE} ${FORGE_OS_LOGGING} ${FORGE_OS_MATH} ${FORGE_OS_MEMORYTRACKING}
	${FORGE_OS_PROFILER} ${FORGE_RENDERER} ${FORGE_EASTL} ${FORGE_SPIRVTOOLS} ${FORGE_SPIRVCROSS} ${FORGE_BASIS_TRANSCODER} ${FORGE_ZIP} ${FORGE_UI} ${FORGE_TEXT}
	${FORGE_UI_IMGUI} ${FORGE_RMEM} ${FORGE_LUA} ${FORGE_LUA_MIDDLEWARE})

#add the lib
add_library(the-forge STATIC ${SOURCE_LIST})

target_include_directories(the-forge PUBLIC ${FORGE_INCLUDES})
target_compile_definitions(the-forge PUBLIC ${FORGE_DEFS})

target_compile_definitions(the-forge PUBLIC $<$<CONFIG:Debug>:_DEBUG>)
target_compile_definitions(the-forge PUBLIC $<$<CONFIG:Debug>:USE_MEMORY_TRACKING>)

#eastl needs this enabled
if(MSVC)
   set_target_properties(the-forge PROPERTIES COMPILE_FLAGS "/Zc:wchar_t")
endif()

#Project solution folders
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${SOURCE_LIST})
