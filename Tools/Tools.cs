using System;
using System.Net.Mail;
using System.Web;
using System.Net;
using System.Threading;
using System.IO;

namespace MobiPlusTools
{
    public static class Tools
    {
        private static readonly Object obj = new Object();

        public static void HandleError(Exception ex, string LogDirectory, string SessionUserID = "", string SessionUserPromt = "", string FileName = "MobiPlusLog")
        {
            string ip = "";
            if (HttpContext.Current != null)
                ip = HttpContext.Current.Request.UserHostAddress;

            string ErrMSG = "UserID: " + SessionUserID;
            ErrMSG += "; User Name: " + SessionUserPromt + ";\r\n";

            ErrMSG += "clientIPAddress: " + ip + "\r\n";

            Exception realerror = ex;

            while (realerror != null && realerror.Message != null)
            {
                ErrMSG += realerror.StackTrace + ";\r\nMessage: " + realerror.Message;
                realerror = realerror.InnerException;
            }
            //SendMail("gil@mtns.co.il", "gil@mtns.co.il","Gilgo","Error Mail","","",ErrMSG,"gil@mtns.co.il","25279NN@");
            AddRowToLog(ErrMSG, LogDirectory, FileName);
        }
        public static bool SendMail(string To, string MSG, string bFile, string FileName)
        {
            try
            {
                var t = new Thread(() => SendMailLocal(To, MSG, bFile, FileName));
                t.Start();

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public static void SendMailLocal(string To, string MSG, string bFile, string FileName)
        {
            try
            {
                string MyMail = "MobiPlusWeb@gmail.com";
                string From = "MobiPlus" + " <" + MyMail + ">";
                //string To2 = "gil@mtns.co.il";
                string Subject = "הודעה מMobiPlus";
                string host = "smtp.gmail.com";
                int port = 587;
                bool istoEnableSsl = true;
                string UserName = "MobiTasks@gmail.com";
                string Password = "mobitasks5544";

                try
                {
                    MailMessage mM = new MailMessage();
                    mM.From = new MailAddress(From);
                    mM.To.Add(To);
                    //mM.To.Add(To2);
                    mM.Subject = Subject;
                    mM.Body = MSG;
                    if (bFile != null)
                    {
                        MemoryStream stream = new MemoryStream(Convert.FromBase64String(bFile));
                        Attachment ai = new Attachment(stream, FileName);
                        mM.Attachments.Add(ai);
                    }
                    mM.IsBodyHtml = true;
                    SmtpClient sC = new SmtpClient(host);
                    sC.Port = port;
                    sC.Credentials = new NetworkCredential(UserName, Password);
                    sC.EnableSsl = istoEnableSsl;
                    sC.Send(mM);
                }
                catch (Exception ex)
                {
                }
            }
            catch (Exception ex)
            {
            }
        }
        public static bool AddRowToLog(string Row, string LogDirectory, string fileName = "MobiPlusLog")
        {
            bool res = true;
            try {
                if (!Directory.Exists(LogDirectory))
                    Directory.CreateDirectory(LogDirectory);

               
                Row = DateTime.Now.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString() + " " + DateTime.Now.Hour.ToString() + ":" + DateTime.Now.Minute.ToString() + ":" + DateTime.Now.Second.ToString() + ": " + Row;
                string FileName = fileName + "_" + DateTime.Now.Day.ToString() + "_" + DateTime.Now.Month.ToString() + "_" + DateTime.Now.Year.ToString();
                try
                {
                    lock (obj)
                    {
                        using (System.IO.StreamWriter file = new System.IO.StreamWriter(LogDirectory + "\\" + FileName, true))
                        {
                            if (fileName == "MobiPlusLog")
                                file.WriteLine("******************************************************************************************************************************************************************************************************************");
                            file.WriteLine(Row);
                        }
                    }
                }
                catch (Exception ex)
                {
                    res = false;
                }
            }
            catch (Exception ex)
            {
                res = false;
            }
            return res;
        }

        public static int? ToNullableInt(this string s)
        {
            int i;
            if (int.TryParse(s, out i)) return i;
            return null;
        }
        public static long? ToNullableLong(this string s)
        {
            long i;
            if (long.TryParse(s, out i)) return i;
            return null;
        }
    }
}
