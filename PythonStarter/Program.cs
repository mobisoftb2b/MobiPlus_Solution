using System;
using System.Configuration;
using System.Security.Cryptography.X509Certificates;
using System.Collections.Generic;
using System.Data;
using System.Threading;
using System.ServiceProcess;
using MobiPlusTools;
using System.Net.Security;
using System.Net.Sockets;
using System.Security.Authentication;
using System.Diagnostics;

namespace PythonStarter
{
    //cd c:\windows\system32
    //sc delete PythonStarter
    //sc create PythonStarterService binpath= "C:\Vss.Net\MobiPlus_Solution\PythonStarter\bin\Release\PythonStarter.exe"


    class PythonStarter : System.ServiceProcess.ServiceBase
    {
        private static bool isRunning = true;
        private static bool isStopedOnSuterday = false;
        public static string LogDirectory = @"c:\Loggeer\PythonStarter\";
        public static string ProjectDirectory = @"C:\Vss.Python\B2BServer\B2BServer\";
        public static string LogFileName = @"PythonStarter";
        private static Thread t;
        static void Main(string[] args)
        {
            if (System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"] != null)
                LogDirectory = System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"].ToString();

            if (System.Configuration.ConfigurationSettings.AppSettings["ProjectDirectory"] != null)
                ProjectDirectory = System.Configuration.ConfigurationSettings.AppSettings["ProjectDirectory"].ToString();
     

            System.ServiceProcess.ServiceBase[] ServicesToRun;

            ServicesToRun = new System.ServiceProcess.ServiceBase[] { new PythonStarter() };
            System.ServiceProcess.ServiceBase.Run(ServicesToRun);

            Thread t = new Thread(PythonStarter.DoWork);
            t.Start();

            Tools.AddRowToLog("Start Service 1", LogDirectory, LogFileName);
        }

        protected override void OnStart(string[] args)
        {
            Tools.AddRowToLog("Start Service", LogDirectory, LogFileName);

            isRunning = true;

            if (System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"] != null)
                LogDirectory = System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"].ToString();

            
            t = new Thread(DoWork);
            t.Start();

            Thread t2 = new Thread(KillPython);
            t2.Start();

            
        }

        protected override void OnStop()
        {
            isRunning = false;
            Tools.AddRowToLog("Stop Service", LogDirectory, LogFileName);
        }
        private static void KillPython()
        {
            while(isRunning)
            {
                Thread.Sleep(100);
            }

            Tools.AddRowToLog("DoWork start", LogDirectory, LogFileName);
            Process cmd = new Process();
            cmd.StartInfo.FileName = "cmd.exe";
            cmd.StartInfo.RedirectStandardInput = true;
            cmd.StartInfo.RedirectStandardOutput = true;
            cmd.StartInfo.CreateNoWindow = true;
            cmd.StartInfo.UseShellExecute = false;
            cmd.Start();

            cmd.StandardInput.WriteLine(@"taskkill /im python.exe /f");
            //cmd.StandardInput.WriteLine(@"exit");
            cmd.StandardInput.Flush();
            cmd.StandardInput.Close();
            //cmd.WaitForExit();
            Console.WriteLine(cmd.StandardOutput.ReadToEnd());
        }
        private static void DoWork()
        {
            try
            {
                Tools.AddRowToLog("DoWork start", LogDirectory, LogFileName);
                Process cmd = new Process();
                cmd.StartInfo.FileName = "cmd.exe";
                cmd.StartInfo.RedirectStandardInput = true;
                cmd.StartInfo.RedirectStandardOutput = true;
                cmd.StartInfo.CreateNoWindow = true;
                cmd.StartInfo.UseShellExecute = false;
                cmd.Start();

                cmd.StandardInput.WriteLine(ProjectDirectory + @"manage.py runserver 0.0.0.0:8000");
                //cmd.StandardInput.WriteLine(@"exit");
                cmd.StandardInput.Flush();
                cmd.StandardInput.Close();
                //cmd.WaitForExit();
                Console.WriteLine(cmd.StandardOutput.ReadToEnd());
            }//taskkill /im myprocess.exe /f
            catch (Exception ex)
            {
                Tools.AddRowToLog("DoWork error: "+ ex.Message, LogDirectory, LogFileName);
            }
            //while (isRunning)
            //{
            //    try
            //    {
            //        //if (DateTime.Now.DayOfWeek == DayOfWeek.Saturday && DateTime.Now.Hour == 11 && DateTime.Now.Minute == 11)
            //        Tools.AddRowToLog("DoWork isRunning", LogDirectory, LogFileName);
            //    }
            //    catch (Exception ex)
            //    {
            //        Tools.AddRowToLog("DoWork2 error: " + ex.Message, LogDirectory, LogFileName);
            //    }
            //    Thread.Sleep(60);
            //}
        }
        public static void StopService(string serviceName, int timeoutMilliseconds)
        {
            isRunning = false;

        }
        public static void StartService(string serviceName, int timeoutMilliseconds)
        {
            ServiceController service = new ServiceController(serviceName);
            try
            {
                TimeSpan timeout = TimeSpan.FromMilliseconds(timeoutMilliseconds);

                service.Start();
                service.WaitForStatus(ServiceControllerStatus.Running, timeout);
            }
            catch
            {
                // ...
            }
        }

    }

}
