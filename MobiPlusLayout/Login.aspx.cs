using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Configuration;
using System.Web.UI.HtmlControls;
using System.Net;
using System.Xml;
using System.Collections.Specialized;

public partial class Login : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }

    }
    private void init()
    {
        Session.Clear();
        Session.Abandon();
        HttpContext.Current.Cache.Remove("LayoutTextSources");

        hidCountryIP.Value = GetCountryByIP(Request.UserHostAddress);

        string Country = "israel";
        Lang = "En";
        if (Country.ToLower().IndexOf("israel") > -1 || Country.ToLower().IndexOf("private range") > -1)
            Lang = "He";


        //SessionLanguage = "Hebrew";

        //projects
        string[] arr = ConStrings.DicAllConStrings.Keys.ToArray<string>();
        if (ConStrings.DicAllConStrings != null)
        {
            if (ConStrings.DicAllConStrings.Keys.Count == 1)//only one
            {
                SessionProjectName = arr[0];
                HttpContext.Current.Session["SessionProjectName"] = arr[0];
                divAllProjects.Visible = false;

                ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "jkey1", "$('#dBody').unblock();" + "SetProjectName('" + arr[0] + "');", true);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "jkey5441", " $('#dBody').block({ message: '' });", true);
                for (int i = 0; i < arr.Length; i++)
                {
                    HtmlGenericControl dynDiv = new HtmlGenericControl("div");
                    dynDiv.Attributes["class"] = "prItem";
                    dynDiv.Attributes["onclick"] = "SetProjectName('" + arr[i] + "');";
                    dynDiv.InnerText = arr[i];
                    divAllProjects.Controls.Add(dynDiv);
                }
            }
        }
        //end projects
    }
    public string GetCountryByIP(string ipAddress)
    {
        //return "israel"; //avi 15-06-17

        //string externalip = new WebClient().DownloadString("http://icanhazip.com");
        IPHostEntry IPHost = Dns.GetHostEntry(Dns.GetHostName());
        string externalip = IPHost.AddressList[0].ToString();
        //string externalip = HttpContext.Current.Request.UserHostAddress;// Context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        if (string.IsNullOrEmpty(externalip))
        {
            externalip = Context.Request.ServerVariables["REMOTE_ADDR"];
        }


        string strReturnVal="127.0.0.1";
        try
        {
            string ipResponse = IPRequestHelper("http://ip-api.com/xml/" + ipAddress);

            //return ipResponse;
            XmlDocument ipInfoXML = new XmlDocument();
            ipInfoXML.LoadXml(ipResponse);
            XmlNodeList responseXML = ipInfoXML.GetElementsByTagName("query");

            NameValueCollection dataXML = new NameValueCollection();

            dataXML.Add(responseXML.Item(0).ChildNodes[2].InnerText, responseXML.Item(0).ChildNodes[2].Value);

            strReturnVal = responseXML.Item(0).ChildNodes[1].InnerText.ToString(); // Contry
            strReturnVal += "(" +

            responseXML.Item(0).ChildNodes[2].InnerText.ToString() + ")";  // Contry Code 
        }
        catch (Exception ex)
        {
            MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString());
        }
        ///return string.Format("{0}({1})", externalip, strReturnVal);
        return strReturnVal;
    }

    private string GetIpAddress()  // Get IP Address
    {
        string url = "http://checkip.dyndns.org";
        WebRequest req = System.Net.WebRequest.Create(url);
        System.Net.WebResponse resp = req.GetResponse();
        System.IO.StreamReader sr = new System.IO.StreamReader(resp.GetResponseStream());
        string response = sr.ReadToEnd().Trim();
        string[] a = response.Split(':');
        string a2 = a[1].Substring(1);
        string[] a3 = a2.Split('<');
        string a4 = a3[0];
        return a4;
    }
    private string GetCompCode()  // Get Computer Name
    {
        string strHostName = "";
        strHostName = Dns.GetHostName();
        return strHostName;
    }
    public string IPRequestHelper(string url)
    {

        HttpWebRequest objRequest = (HttpWebRequest)WebRequest.Create(url);
        HttpWebResponse objResponse = (HttpWebResponse)objRequest.GetResponse();

        StreamReader responseStream = new StreamReader(objResponse.GetResponseStream());
        string responseRead = responseStream.ReadToEnd();

        responseStream.Close();
        responseStream.Dispose();

        return responseRead;
    }
}