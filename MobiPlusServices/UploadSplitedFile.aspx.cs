using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data;
using System.Web.Script.Serialization;
using System.Text;


using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.Caching;
using System.IO;
using System.IO.Compression;
//using Ionic.Zip;
using System.Diagnostics;
using CacheHandler;
using System.Drawing;
using MobiPlusTools;
using Newtonsoft.Json;
using System.Runtime.Serialization;
using Resco.IO.Zip;
using System.Threading;



public partial class UploadSplitedFile : System.Web.UI.Page
{
    private string LogDir = ConfigurationManager.AppSettings["LogDirectory"].ToString();
    private static readonly Object objLock = new Object();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            UploadFileM();
        }
    }
    private void UploadFileM()
    {
        if (Request.Files.Count > 0)
        {
            try
            {
                string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString() + "SplitedZip\\";
                if (!(Directory.Exists(Dir)))
                {
                    Directory.CreateDirectory(Dir);
                }

                HttpPostedFile file = Request.Files[0];
                byte[] bFile = new byte[file.ContentLength];
                file.InputStream.Read(bFile, 0, file.ContentLength);

                File.WriteAllBytes(Dir + Request.Files[0].FileName, bFile);
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                ResponseToUpload(500, "Not Ok");
                return;
            }
            ResponseToUpload(200, "Ok");
            return;
        }
        else if (Request.QueryString["MobiUnSplited"] != null && Request.QueryString["FileName"] != null && Request.QueryString["MobiUnSplited"].ToString() == "true")
        {
            UnSplitZips(Request.QueryString["FileName"].ToString());
            return;
        }
        ResponseToUpload(404, "404  - Not Found");
        //ResponseToUpload(500, "500 InternalServerError");      
    }

    private void ResponseToUpload(int Status, string Msg)
    {
        try
        {
            //Response.ClearHeaders();
            //Response.ClearContent();
            if (Status != 200)
                Response.Status = Msg;
            Response.StatusCode = Status;
            Response.StatusDescription = Msg;
            //Response.Flush();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    private void p()
    {
    }
    private void UnSplitZips(string resFileName)
    {
        try{
            long BytesReceived = 0;
            string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString() + "SplitedZip\\";
            if (!(Directory.Exists(Dir)))
            {
                Directory.CreateDirectory(Dir);
            }
            //string[] files = Directory.GetFiles(Dir, "*" + resFileName.Replace(".zip", "") + "*").OrderBy(f => f);
            var FilesSorted = Directory.GetFiles(Dir, "*" + resFileName.Replace(".zip", "") + "*").Select(fn => new FileInfo(fn)).OrderBy(f => Convert.ToInt64(f.Name.Replace(".zip", "").Split('_')[1]));

            string DirInin = ConfigurationManager.AppSettings["UploadFiles"].ToString() + "UnSplitedZip\\" + resFileName.Replace(".zip", "") + "\\";
            if (!(Directory.Exists(DirInin)))
            {
                Directory.CreateDirectory(DirInin);
            }
            string DirIn = ConfigurationManager.AppSettings["UploadFiles"].ToString() + "UnSplitedZip\\" + resFileName.Replace(".zip", "") + "\\";
            if (!(Directory.Exists(DirIn)))
            {
                Directory.CreateDirectory(DirIn);
            }
            int counter = 1;
            string OrgFileName = "";
            FileStream streamWriter = null;
            {
                //for (int i = 0; i < files.Length; i++)
                foreach (var item in FilesSorted)
                {

                    FileInfo fi = item;
                
                    Resco.IO.Zip.ZipArchive z = null;
                    try
                    {
                        if (fi.Exists)
                        {
                            using (ICSharpCode.SharpZipLib.Zip.ZipInputStream s = new ICSharpCode.SharpZipLib.Zip.ZipInputStream(File.OpenRead(fi.FullName)))
                            {
                                BytesReceived += new FileInfo(fi.FullName).Length;

                                ICSharpCode.SharpZipLib.Zip.ZipEntry theEntry;
                                while ((theEntry = s.GetNextEntry()) != null)
                                {
                                    string directoryName = Path.GetDirectoryName(theEntry.Name);
                                    string fileName = Path.GetFileName(theEntry.Name);
                                    if (fileName != OrgFileName)
                                    {
                                        OrgFileName = fileName;

                                        if (streamWriter != null)
                                        {
                                            streamWriter.Flush();
                                            streamWriter.Close();
                                        }
                                        streamWriter = File.Create(DirInin + OrgFileName);
                                    }

                                    // create directory
                                    if (directoryName.Length > 0)
                                    {
                                        Directory.CreateDirectory(directoryName);
                                    }

                                    if (fileName != String.Empty)
                                    {


                                        int size = 2048;
                                        byte[] data = new byte[2048];
                                        while (true)
                                        {
                                            size = s.Read(data, 0, data.Length);
                                            if (size > 0)
                                            {
                                                streamWriter.Write(data, 0, size);                                                
                                            }
                                            else
                                            {
                                                break;
                                            }
                                        }

                                        counter++;
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Tools.HandleError(ex, LogDir);
                    }
                
                    //delete uploaded zip file
                    fi.Delete();
                }
            }
            if (streamWriter != null)
            {
                streamWriter.Flush();
                streamWriter.Close();
            }
           
            

            lock (objLock)
            {
                if (BytesReceived == Convert.ToInt64(Request.QueryString["BLen"].ToString()))
                {
                    string[] files2 = Directory.GetFiles(DirIn, "*");
                    //create new zip for all the files
                    Resco.IO.Zip.ZipArchive z2 = new Resco.IO.Zip.ZipArchive(DirIn + resFileName, Resco.IO.Zip.ZipArchiveMode.Create, FileShare.None);
                    for (int i = 0; i < files2.Length; i++)
                    {
                        z2.Add(files2[i], "", true, null);
                    }
                    z2.Close();

                    //Thread.Sleep(500);

                    string DirOrg = ConfigurationManager.AppSettings["UploadFiles"].ToString();
                    if (new FileInfo(DirOrg + "tmp_" + resFileName).Exists)
                        new FileInfo(DirOrg + "tmp_" + resFileName).Delete();

                    //copy zip to avi upload dir
                    File.Copy(DirIn + resFileName, DirOrg + "tmp_" + resFileName);

                    //Thread.Sleep(500);

                    //delete unzips
                    foreach (System.IO.FileInfo file in new DirectoryInfo(DirIn).GetFiles()) file.Delete();
                    foreach (System.IO.DirectoryInfo subDirectory in new DirectoryInfo(DirIn).GetDirectories()) subDirectory.Delete(true);
                }
                else
                {
                    ResponseToUpload(500, "500  - Error UbZip - BytesReceived: " + BytesReceived.ToString());
                    return;
                }
            }
            ResponseToUpload(200, "Ok");
        }
        catch (Exception ex)
        {
            ResponseToUpload(500, "500  - Error UbZip");
            Tools.HandleError(ex, LogDir);
        }
    }


}
