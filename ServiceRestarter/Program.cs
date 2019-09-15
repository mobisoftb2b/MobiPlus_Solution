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
namespace ServiceRestarter
{
    //cd c:\windows\system32
    //sc delete ServiceRestarter
    //sc create ServiceRestarter binpath= "C:\Projects\MobiPlus_Solution\ServiceRestarter\bin\Release\ServiceRestarter.exe"

    class ServiceRestarter : System.ServiceProcess.ServiceBase
    {
        private static bool isRunning = true;
        private static bool isStopedOnSuterday = false;
        public static string LogDirectory = @"c:\Loggeer\ServiceRestarter\";
        public static string LogFileName = @"ServiceRestarter";

        static void Main(string[] args)
        {
            if (System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"] != null)
                LogDirectory = System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"].ToString();

            System.ServiceProcess.ServiceBase[] ServicesToRun;

            ServicesToRun = new System.ServiceProcess.ServiceBase[] { new ServiceRestarter() };
            System.ServiceProcess.ServiceBase.Run(ServicesToRun);

            Thread t = new Thread(ServiceRestarter.DoWork);
            t.Start();

            Tools.AddRowToLog("Start Service 1", LogDirectory, LogFileName);
        }

        protected override void OnStart(string[] args)
        {
            Tools.AddRowToLog("Start Service", LogDirectory, LogFileName);

            isRunning = true;

            if (System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"] != null)
                LogDirectory = System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"].ToString();

            Thread t = new Thread(ServiceRestarter.DoWork);
            t.Start();
        }

        protected override void OnStop()
        {
            isRunning = false;
            Tools.AddRowToLog("Stop Service", LogDirectory, LogFileName);
        }
        private static void DoWork()
        {
            while (isRunning)
            {
                //if (DateTime.Now.DayOfWeek == DayOfWeek.Saturday && DateTime.Now.Hour == 11 && DateTime.Now.Minute == 11)
                if (DateTime.Now.DayOfWeek == DayOfWeek.Saturday && !isStopedOnSuterday)
                {
                    isStopedOnSuterday = true;
                    StopService("PushServerService",15000);
                }

                if (DateTime.Now.DayOfWeek == DayOfWeek.Sunday && isStopedOnSuterday)
                {
                    isStopedOnSuterday = false;
                }

                Thread.Sleep(60*1000*5);//5 דקות
            }
        }
        public static void StopService(string serviceName, int timeoutMilliseconds)
        {
            bool isStart = false;
            ServiceController service = new ServiceController(serviceName);
            try
            {
                TimeSpan timeout = TimeSpan.FromMilliseconds(timeoutMilliseconds);

                Tools.AddRowToLog("Stop 1 Service PushServerService", LogDirectory, LogFileName);

                service.Stop();
                service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
            }
            catch(Exception ex)
            {
                try
                {
                    TimeSpan timeout = TimeSpan.FromMilliseconds(timeoutMilliseconds);

                    Tools.AddRowToLog("Stop 2 Service PushServerService", LogDirectory, LogFileName);

                    service.Stop();
                    service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
                }
                catch (Exception ex1)
                {
                    isStart = true;
                    Tools.AddRowToLog("Start Service 1 PushServerService", LogDirectory, LogFileName);
                    StartService("PushServerService", 25000);
                }
            }

            if (!isStart)
            {
                Tools.AddRowToLog("Start Service 2 PushServerService", LogDirectory, LogFileName);
                StartService("PushServerService", 25000);
            }

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
