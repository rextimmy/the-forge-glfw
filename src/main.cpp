//-----------------------------------------------------------------------------
// Copyright 2020 Tim Barnes
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//----------------------------------------------------------------------------

#include "demo.h"
#include <GLFW/glfw3.h>

//GLFW callbacks
void errorCallback(int, const char* description)
{
	printf("GLFW error: %s\n", description);
}

void framebufferResizeCallback(GLFWwindow *pWin, int w, int h)
{
	Demo *pDemo = static_cast<Demo*>(glfwGetWindowUserPointer(pWin));
	assert(pDemo);
	pDemo->onSize(w, h);
}

void mouseButtonCallback(GLFWwindow* pWin, int button, int action, int)
{
	Demo *pDemo = static_cast<Demo*>(glfwGetWindowUserPointer(pWin));
	assert(pDemo);
	pDemo->onMouseButton(button, action);
}

//Main
#ifdef _WIN32
int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
#else
int main(int argc, const char **argv)
#endif
{
	//install glfw error callback first
	glfwSetErrorCallback(errorCallback);
	//init glfw
	if (!glfwInit())
      exit(EXIT_FAILURE);

	//we want glfw to not create any api with window creation
	glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
	glfwWindowHint(GLFW_MAXIMIZED, GLFW_TRUE);
	GLFWwindow *pWindow = glfwCreateWindow(800, 600, "The-Forge Demo", NULL, NULL);
	if (!pWindow)
	{
		glfwTerminate();
      exit(EXIT_FAILURE);
	}

	//Demo class
	Demo demo;

	if (!demo.init(pWindow))
	{
		glfwTerminate();
      exit(EXIT_FAILURE);
	}

	//set the demo class as the user pointer
	glfwSetWindowUserPointer(pWindow, &demo);
	//framebuffer size callback
	glfwSetFramebufferSizeCallback(pWindow, framebufferResizeCallback);
	//mouse button callback
	glfwSetMouseButtonCallback(pWindow, mouseButtonCallback);

	while (!glfwWindowShouldClose(pWindow))
	{
		//poll events
		glfwPollEvents();

		//render
		demo.onRender();
	}

	glfwDestroyWindow(pWindow);
	glfwTerminate();
	
   exit(EXIT_SUCCESS);
} 
