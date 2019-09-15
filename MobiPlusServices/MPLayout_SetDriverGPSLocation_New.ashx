<%@ WebHandler Language="C#" Class="MPLayout_SetDriverGPSLocation_New" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Collections.Generic;
using System.Configuration;
using MobiPlusTools;
using System.Linq;
using System.Xml.Linq;

namespace MobiPlusServices
{
    public class MPLayout_SetDriverGPSLocation_New : IHttpHandler
    {
        readonly string logDir = ConfigurationManager.AppSettings["LogDirectory"];
        public void ProcessRequest(HttpContext context)
        {
            string json = new StreamReader(context.Request.InputStream).ReadToEnd();
            XDocument _xdoc = new XDocument();
            string result = string.Empty;
            try
            {
                if (!string.IsNullOrEmpty(json))
                {
                    JObject jObject = JObject.Parse(json);
                    JToken jUser = jObject["jsonText"];

                    string AgentID = (string)jUser["AgentID"];

                    var Location = jUser["Locations"].ToString();
                    JavaScriptSerializer js = new JavaScriptSerializer();
                    var locationObj = js.Deserialize<List<Locations>>(Location);
                    _xdoc = new XDocument(
                             new XElement("DriverGPSLocation",
                                 from j in locationObj
                                 select new XElement("GPSLocation",
                                          new XAttribute("Lat", j.Latitude),
                                          new XAttribute("Lon", j.Longitude),
                                          new XAttribute("DateTime", j.DateTime))));


                    result = DAL.DAL.MPLayout_SetDriverGPSLocationXML(AgentID, _xdoc.ToString());

                    context.Response.Clear();
                    context.Response.ContentType = "application/json";
                    context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
                    context.Response.AddHeader("content-length", result.Length.ToString());
                    context.Response.Flush();
                    context.Response.Write(result);
                }
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, logDir);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

    }

    public class Locations
    {
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string DateTime { get; set; }

    }
}