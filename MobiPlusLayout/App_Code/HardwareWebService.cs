using MobiPlusTools;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Globalization;
using System.Configuration;
using MobiPlus.Models.AgentDailyTasks;
using MobiPlus.BusinessLogic.Tasks;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Tasks;
using MobiPlus.BusinessLogic.Layout.FilterSettings;
using MobiPlus.Models.Common;
using MobiPlus.Models.Hardware;

/// <summary>
/// Summary description for HardwareWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class HardwareWebService : System.Web.Services.WebService
{

    #region Utilites

    private string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();
    public string SessionProjectName
    {
        get
        {
            if (System.Web.HttpContext.Current.Session["SessionProjectName"] == null)
                System.Web.HttpContext.Current.Session["SessionProjectName"] = "Dev";
            return System.Web.HttpContext.Current.Session["SessionProjectName"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionProjectName"] = value;
        }
    }
    public string GetConnectionString
    {
        get
        {
            return ConStrings.DicAllConStrings[SessionProjectName];
        }
    }
    public string SessionUserID
    {
        get
        {
            if (Session["UserID"] == null)
                Session["UserID"] = "0";
            return Session["UserID"].ToString();
        }
        set
        {
            HttpContext.Current.Session["UserID"] = value;
        }
    }
    public string SessionLanguage
    {
        get
        {
            if (HttpContext.Current.Session["SessionLanguage"] == null)
                HttpContext.Current.Session["SessionLanguage"] = "He";
            return (string)HttpContext.Current.Session["SessionLanguage"];
        }
        set
        {
            HttpContext.Current.Session["SessionLanguage"] = value;
        }
    }
    public string GetCountryIDByLanguage()
    {
        string result = string.Empty;
        switch (SessionLanguage.ToLower())
        {
            case "he":
                result = "1000";
                break;
            case "en":
                result = "8000";
                break;
            case "ge":
                result = "5000";
                break;
        }
        return result;
    }

    public string GetCorrectDate(string input)
    {
        string[] arrDate = input.Split('/');
        return arrDate[2] + arrDate[1] + arrDate[0];
    }
    #endregion

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Device4Driver_Select(string cid, string did, string driverID, string deviceID)
    {
        DataTable table = null;
        var hardware = new List<Device4Driver>();
        var filtered = new List<Device4Driver>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Device4Driver_Select(driverID, deviceID, GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new Device4Driver
            {
                ID = int.Parse(a["MP_ID"].ToString()),
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DriverID = a["MP_DriverID"].ToString(),
                DriverName = a["MP_DriverName"].ToString(),
                Comments = a["MP_Comment"].ToString(),
                IsActive = bool.Parse(a["MP_IsActive"].ToString()),
                CountryID = a["CountryID"].ToString(),
                DistrID = a["DistrID"].ToString()
            }).ToList();
            if (string.IsNullOrEmpty(cid)) filtered = hardware;
            else filtered = hardware.Where(a => a.CountryID == cid).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(filtered, filtered.Count, 10, filtered.Count == 0 ? 1 : filtered.Count));
    }

    #region Devices handle

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Devices_SelectAll(string driverID, int? countryID)
    {
        var filtered = new List<DeviceModel>();
        var devices = DevicesList_SelectAll(driverID, countryID.ToString());
        if (countryID != null) filtered = devices;
        else filtered = devices.Where(a => a.CountryID == countryID).ToList();
        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(filtered, filtered.Count, 10, filtered.Count == 0 ? 1 : filtered.Count));
    }

    [WebMethod(EnableSession = true)]
    public List<DeviceModel> Devices_SelectList(string letter)
    {
        List<DeviceModel> fetchFirst = null;
        try
        {
            {
                fetchFirst = DevicesList_SelectAll(null).Where(m => m.DeviceID.ToLower().Contains(letter.ToLower()))
                    .GroupBy(a => new { a.DeviceID, a.DeviceTypeID }).Select(a => new DeviceModel { DeviceID = a.Key.DeviceID, DeviceTypeID = a.Key.DeviceTypeID }).ToList(); ;
            }
        }
        catch (Exception ex) { Tools.HandleError(ex, LogDir); }
        return fetchFirst;
    }

    private List<DeviceModel> DevicesList_SelectAll(string driverID)
    {
        DataTable table = null;
        var hardware = new List<DeviceModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.DeviceList_SelectAll(GetCountryIDByLanguage(), driverID, GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new DeviceModel
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DeviceTypeID = int.Parse(a["MP_DeviceTypeID"].ToString()),
                Comment = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                Status = int.Parse(a["MP_StatusID"].ToString()),
                StatusName = a["MP_StatusName"].ToString(),
                isBusy = bool.Parse(a["IsBusy"].ToString()),
                CountryID = int.Parse(a["CountryID"].ToString())
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return hardware;
    }
    private List<DeviceModel> DevicesList_SelectAll(string driverID, string countryID)
    {
        DataTable table = null;
        var hardware = new List<DeviceModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.DeviceList_SelectAll(countryID, driverID, GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new DeviceModel
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DeviceTypeID = int.Parse(a["MP_DeviceTypeID"].ToString()),
                Comment = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                Status = int.Parse(a["MP_StatusID"].ToString()),
                StatusName = a["MP_StatusName"].ToString(),
                isBusy = bool.Parse(a["IsBusy"].ToString()),
                CountryID = int.Parse(a["CountryID"].ToString())
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return hardware;
    }
    private List<DeviceModel> DevicesList_SelectAll()
    {
        DataTable table = null;
        var hardware = new List<DeviceModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.DeviceList_SelectAll(GetCountryIDByLanguage(), null, GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new DeviceModel
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DeviceTypeID = int.Parse(a["MP_DeviceTypeID"].ToString()),
                Comment = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                Status = int.Parse(a["MP_StatusID"].ToString()),
                StatusName = a["MP_StatusName"].ToString(),
                isBusy = bool.Parse(a["IsBusy"].ToString()),
                CountryID = int.Parse(a["CountryID"].ToString())
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return hardware;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Devices_Save(DeviceModel device)
    {
        DataTable table = null;
        var hardware = new List<DeviceModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Devices_Save(device.ID, device.DeviceTypeID, device.DeviceID, device.Status, device.CountryID, device.Comment, SessionUserID, GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new DeviceModel
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DeviceTypeID = int.Parse(a["MP_DeviceTypeID"].ToString()),
                Comment = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                Status = int.Parse(a["MP_StatusID"].ToString())
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(hardware, hardware.Count, 10, hardware.Count == 0 ? 1 : hardware.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public DeviceModel DeviceInfo_Select(int id)
    {
        DataTable table = null;
        var hardware = new DeviceModel();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.DeviceInfo_Select(id, GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new DeviceModel
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DeviceTypeID = int.Parse(a["MP_DeviceTypeID"].ToString()),
                Comment = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                Status = int.Parse(a["MP_StatusID"].ToString()),
                CountryID = int.Parse(a["CountryID"].ToString())
            }).FirstOrDefault();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return hardware;
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Status_SelectAll()
    {
        DataTable table = null;
        var hardware = new List<StatusModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Status_SelectAll(GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new StatusModel
            {
                StatusID = int.Parse(a["MP_StatusID"].ToString()),
                StatusDesc = a["MP_StatusName"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(hardware, hardware.Count, 10, hardware.Count == 0 ? 1 : hardware.Count));
    }
    #endregion

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveDevices4Drivers(Device4Driver param)
    {
        DataTable table = null;
        var hardware = new List<Device4Driver>();
        var filtered = new List<Device4Driver>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.SaveDevices4Drivers(param.ID, param.DriverID, param.DeviceID, param.IsActive, param.Comments, int.Parse(SessionUserID), GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new Device4Driver
            {
                ID = int.Parse(a["MP_ID"].ToString()),
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DriverID = a["MP_DriverID"].ToString(),
                DriverName = a["MP_DriverName"].ToString(),
                Comments = a["MP_Comment"].ToString(),
                IsActive = bool.Parse(a["MP_IsActive"].ToString()),
                CountryID = a["CountryID"].ToString(),
                DistrID = a["DistrID"].ToString()
            }).ToList();
            if (string.IsNullOrEmpty(param.CountryID)) filtered = hardware;
            else filtered = hardware.Where(a => a.CountryID == param.CountryID).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(filtered, filtered.Count, 10, filtered.Count == 0 ? 1 : filtered.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string DeleteDevice4Driver(Device4Driver param)
    {
        DataTable table = null;
        var hardware = new List<Device4Driver>();
        var filtered = new List<Device4Driver>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.DeleteDevice4Driver(param.ID, GetConnectionString);
            }

            hardware = table.AsEnumerable().Select(a => new Device4Driver
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                Comments = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                IsActive = bool.Parse(a["MP_IsActive"].ToString()),
                DriverID = a["MP_DriverID"].ToString(),
                DriverName = a["MP_DriverName"].ToString(),
                CountryID = a["CountryID"].ToString(),
                DistrID = a["DistrID"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        if (string.IsNullOrEmpty(param.CountryID)) filtered = hardware;
        else filtered = hardware.Where(a => a.CountryID == param.CountryID).ToList();

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(filtered, filtered.Count, 10, filtered.Count == 0 ? 1 : filtered.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public Device4Driver CheckDeviceOwner(string deviceID)
    {
        DataTable table = null;
        var hardware = new Device4Driver();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.CheckDeviceOwner(deviceID, GetConnectionString);
            }
            hardware = table.AsEnumerable().Select(a => new Device4Driver
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                Comments = a["MP_Comment"].ToString(),
                DriverID = a["MP_DriverID"].ToString(),
                DriverName = a["MP_DriverName"].ToString()
            }).FirstOrDefault();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return hardware;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ChangeDeviceOwner(string deviceID, string driverID)
    {
        DataTable table = null;
        var hardware = new List<Device4Driver>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.ChangeDeviceOwner(deviceID, driverID, int.Parse(SessionUserID), GetConnectionString);
            }
            hardware = table.AsEnumerable().Select(a => new Device4Driver
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                Comments = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                IsActive = bool.Parse(a["MP_IsActive"].ToString()),
                DriverID = a["MP_DriverID"].ToString(),
                DriverName = a["MP_DriverName"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(hardware, hardware.Count, 10, hardware.Count == 0 ? 1 : hardware.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string DeleteDevice(int? id, int? countryID)
    {
        DataTable table = null;
        var hardware = new List<DeviceModel>();
        var filtered = new List<DeviceModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.DeleteDevice(id, GetConnectionString);
            }
            hardware = table.AsEnumerable().Select(a => new DeviceModel
            {
                DeviceID = a["MP_DeviceID"].ToString(),
                DeviceTypeName = a["MP_DeviceTypeName"].ToString(),
                DeviceTypeID = int.Parse(a["MP_DeviceTypeID"].ToString()),
                Comment = a["MP_Comment"].ToString(),
                ID = int.Parse(a["MP_ID"].ToString()),
                Status = int.Parse(a["MP_StatusID"].ToString()),
                StatusName = a["MP_StatusName"].ToString(),
                isBusy = bool.Parse(a["IsBusy"].ToString())
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        if (countryID != null) filtered = hardware;
        else filtered = hardware.Where(a => a.CountryID == countryID).ToList();

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(filtered, filtered.Count, 10, filtered.Count == 0 ? 1 : filtered.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<AgentModel> GetAgents_SelectAll(string cid, string did)
    {
        DataTable table = null;
        var hardware = new List<AgentModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.GetAgents_SelectAll(SessionUserID, cid, did, GetConnectionString);
            }
            hardware = table.AsEnumerable().Select(a => new AgentModel
            {
                AgentID = int.Parse(a["AgentId"].ToString()),
                AgentName = a["AgentName"].ToString(),
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return hardware;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<DeviceModel> DeviceList_SelectAll()
    {
        return this.DevicesList_SelectAll();
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public bool Devices_CheckExisting(DeviceModel device)
    {
        var devices = this.DevicesList_SelectAll();
        var result = devices.Where(a => a.DeviceID == device.DeviceID).FirstOrDefault();
        if (result == null)
            return false;
        if (result.ID == device.ID)
            return false;
        return true;
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<AgentModel> MPLayout_GetDriverGPSLocationByCountry(string agentsList, string date, string cid)
    {
        DataTable table = null;
        var hardware = new List<AgentModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.MPLayout_GetDriverGPSLocationByCountry(agentsList, GetCorrectDate(date), cid, GetConnectionString);
            }
            hardware = table.AsEnumerable().Select(a => new AgentModel
            {
                AgentID = int.Parse(a["AgentCode"].ToString()),
                AgentName = a["Name"].ToString(),
                DriverGPSLocation = new GPSLocation
                {
                    Comment = a["Comment"].ToString(),
                    Lat = a["Lat"].ToString(),
                    Lng = a["Lon"].ToString(),
                    LocationID = long.Parse(a["DriverGPSLocationID"].ToString())
                }
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return hardware;
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<AgentModel> MPLayout_GetDriverGPSActivity(string date, string cid, string did)
    {
        DataTable table = null;
        DateTime dateParsed = DateTime.Parse(date, CultureInfo.CreateSpecificCulture("he-IL"));
        var hardware = new List<AgentModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.GetDriversByDate(did, cid, dateParsed, GetConnectionString);
            }
            hardware = table.AsEnumerable().Select(a => new AgentModel
            {
                AgentID = int.Parse(a["AgentID"].ToString()),
                AgentName = a["AgentName"].ToString(),
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return hardware;
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string MPLayout_GetCustomersCord(string agentID, string date, string cid, string did)
    {
        DataTable table = null;
        long? countryID = cid.ToNullableLong();
        long? distrID = did.ToNullableLong();
        var hardware = new List<Customer>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.MPLayout_GetCustomersCord(agentID, GetCorrectDate(date), GetConnectionString, countryID, distrID);
            }
            hardware = table.AsEnumerable().Select(a => new Customer
            {
                CustomerID = long.Parse(a["CustID"].ToString()),
                CustomerName = a["CustName"].ToString(),
                Address = a["Address"].ToString(),
                Color = a["Color"].ToString(),
                IsNotSupplayAndVisit = a["IsNotSupplayAndVisit"].ToString() == "0" ? false : true,
                IsVisit = a["IsVisit"].ToString() == "0" ? false : true,
                Location = new GPSLocation
                {
                    Comment = a["Comment"].ToString(),
                    Lat = a["Lat"].ToString(),
                    Lng = a["Lon"].ToString(),
                    ReportGPS_LAT = a["ReportGPS_LAT"].ToString(),
                    ReportGPS_Lon = a["ReportGPS_Lon"].ToString()
                }
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(hardware, hardware.Count, 10, hardware.Count == 0 ? 1 : hardware.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string MPLayout_GetCustomersRoadCord(Agents agents)
    {
        DataTable table = null;
        var hardware = new List<Customer>();
        var tempAgents = new Agents
        {
            AgentID = agents.AgentID,
            CountryID = agents.CountryID,
            Date = GetCorrectDate(agents.Date),
            AgentName = agents.AgentName,
            ColorLine = agents.ColorLine,
            Organization = agents.Organization,
            VisitDate = agents.VisitDate
        };

        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.MPLayout_GetCustomersRoadCord(tempAgents, GetConnectionString);
            }
            hardware = table.AsEnumerable().Where(
                  r => r.Field<string>("SalesOrganization").Contains(tempAgents.CountryID.ToString())).Select(a => new Customer
            {
                AgentCode = long.Parse(a["AgentCode"].ToString()),
                Location = new GPSLocation
                {
                    LocationID = long.Parse(a["DriverGPSLocationID"].ToString()),
                    Lat = a["Lat"].ToString(),
                    Lng = a["Lon"].ToString()
                }
            }).ToList();
            new GPSManager().ClearCoordinates(hardware);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(hardware, hardware.Count, 10, hardware.Count == 0 ? 1 : hardware.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_ConcentrationActivity(int? reportID, string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<ConcActivityModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_ConcentrationActivity(reportID, cid, did, driverID, date, toDate, SessionLanguage.ToLower(), GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new ConcActivityModel
            {
                DriverID = long.Parse(a["AgentId1"].ToString()),
                CountryID = long.Parse(a["CountryID1"].ToString()),
                AgentReturn = a["AgentReturn"].ToString(),
                DistrID = long.Parse(a["DistrID1"].ToString()),
                DriverName = a["DriverName"].ToString(),
                FromDate = a["FromDate1"].ToString(),
                Visit = a["Visit"].ToString(),
                Cycle = a["Cycle"].ToString(),
                ImgStatus = a["imgStatus"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                Mission = a["Mission"].ToString(),
                DriverStatus = a["DriverStatus"].ToString(),
                Progress = a["Progress"].ToString(),
                Delivery = a["Delivery"].ToString(),
                EndSupplyDate = a["EndSupplyDate"].ToString(),
                IdStatus = a["idStatus"].ToString(),
                LongDistance = a["LongDistance"].ToString(),
                NotFullDelivery = a["NotFullDelivery"].ToString(),
                NotVisited = a["NotVisited"].ToString(),
                Shipment = a["Shipment"].ToString(),
                KPI = decimal.Parse(a["KPI"].ToString()),
                TaskDate = a["TaskDate"].ToString(),
                TT = a["TT"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_ConcentrationActivityPopup(string cid, string did, string driverID, string date, string shipment, string cycle)
    {
        DataTable table = null;
        var activity = new List<ConcActivityModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_ConcentrationActivityPopup(cid, did, driverID, date, shipment, cycle, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new ConcActivityModel
            {
                ActualSortOrder = a["ActualSortOrder"].ToString(),
                ByTrack = a["ByTrack"].ToString(),
                AgentReturn = a["CustReturns"].ToString(),
                DriverName = a["Driver"].ToString(),
                FromDate = a["FromDate1"].ToString(),
                Cust = a["Cust"].ToString(),
                Cycle = a["Cycle"].ToString(),
                ImgStatus = a["imgStatus"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                STYLE_DriverReturn = a["STYLE_DriverReturn"].ToString(),
                CustAddress = a["CustAddress"].ToString(),
                TravelHours = a["TravelHours"].ToString(),
                ServiceHours = a["ServiceHours"].ToString(),
                OriginalTime = a["OriginalTime"].ToString(),
                DeliveryTime = a["DeliveryTime"].ToString(),
                Delivery = a["Delivery"].ToString(),
                CustReturns = a["CustReturns"].ToString(),
                CollectedSurfaces = string.IsNullOrEmpty(a["CollectedSurfaces"].ToString()) ? null : (int?)int.Parse(a["CollectedSurfaces"].ToString()),
                STYLE_CollectedSurfaces = a["STYLE_CollectedSurfaces"].ToString(),
                DriverStatus = a["LastStatus"].ToString(),
                Shipment = a["Shipment"].ToString(),
                CustID = a["CustID1"].ToString(),
                SortOrder = string.IsNullOrEmpty(a["SortOrder"].ToString()) ? null : (int?)int.Parse(a["SortOrder"].ToString())
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }
	
    public List<ConcActivityModel> Layout_POD_WEB_ConcentrationActivityExcel(int? reportID, string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<ConcActivityModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_ConcentrationActivity(reportID, cid, did, driverID, date, toDate, "en", ConfigurationManager.AppSettings["Diplomat_WebConnectionString"].ToString());
            }
            activity = table.AsEnumerable().Select(a => new ConcActivityModel
            {
                DriverID = long.Parse(a["AgentId1"].ToString()),
                CountryID = long.Parse(a["CountryID1"].ToString()),
                AgentReturn = a["AgentReturn"].ToString(),
                DistrID = long.Parse(a["DistrID1"].ToString()),
                DriverName = a["DriverName"].ToString(),
                FromDate = a["FromDate1"].ToString(),
                Visit = a["Visit"].ToString(),
                Cycle = a["Cycle"].ToString(),
                ImgStatus = a["imgStatus"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                Mission = a["Mission"].ToString(),
                DriverStatus = a["DriverStatus"].ToString(),
                Progress = a["Progress"].ToString(),
                Delivery = a["Delivery"].ToString(),
                EndSupplyDate = a["EndSupplyDate"].ToString(),
                IdStatus = a["idStatus"].ToString(),
                LongDistance = a["LongDistance"].ToString(),
                NotFullDelivery = a["NotFullDelivery"].ToString(),
                NotVisited = a["NotVisited"].ToString(),
                Shipment = a["Shipment"].ToString(),
                KPI = decimal.Parse(string.IsNullOrEmpty(a["KPI"].ToString()) ? "0" : a["KPI"].ToString()),
                TaskDate = a["TaskDate"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return activity;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_DriverStatus_DSA(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<DriverStatusModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_DriverStatus_DSA(cid, did, driverID, date, toDate, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new DriverStatusModel
            {
                DriverID = long.Parse(a["DriverID"].ToString()),
                DriverName = a["DriverName"].ToString(),
                UpdateDate = a["UpdateDate"].ToString(),
                Cycle = a["Cycle"].ToString(),
                imgLineDownload = a["imgLineDownload"].ToString(),
                STYLE_imgLineDownload = a["STYLE_imgLineDownload"].ToString(),
                imgWise = a["imgWise"].ToString(),
                STYLE_imgWise = a["STYLE_imgWise"].ToString(),
                imgToDiplomat = a["imgToDiplomat"].ToString(),
                STYLE_imgToDiplomat = a["STYLE_imgToDiplomat"].ToString(),
                imgLineEnded = a["imgLineEnded"].ToString(),
                STYLE_imgLineEnded = a["STYLE_imgLineEnded"].ToString(),
                LongDistance = a["LongDistance"].ToString(),
                Period = a["Period"].ToString(),
                imgArriveBB = a["imgArriveBB"].ToString(),
                imgLeaveBB = a["imgLeaveBB"].ToString(),
                TaskDate = a["TaskDate"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }
	 
    public List<DriverStatusModel> Layout_POD_WEB_DriverStatus(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<DriverStatusModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_DriverStatus_DSA(cid, did, driverID, date, toDate, ConfigurationManager.AppSettings["Diplomat_WebConnectionString"].ToString());
            }
            activity = table.AsEnumerable().Select(a => new DriverStatusModel
            {
                DriverID = long.Parse(a["DriverID"].ToString()),
                DriverName = a["DriverName"].ToString(),
                UpdateDate = a["UpdateDate"].ToString(),
                Cycle = a["Cycle"].ToString(),
                imgLineDownload = a["imgLineDownload"].ToString(),
                STYLE_imgLineDownload = a["STYLE_imgLineDownload"].ToString(),
                imgWise = a["imgWise"].ToString(),
                STYLE_imgWise = a["STYLE_imgWise"].ToString(),
                imgToDiplomat = a["imgToDiplomat"].ToString(),
                STYLE_imgToDiplomat = a["STYLE_imgToDiplomat"].ToString(),
                imgLineEnded = a["imgLineEnded"].ToString(),
                STYLE_imgLineEnded = a["STYLE_imgLineEnded"].ToString(),
                LongDistance = a["LongDistance"].ToString(),
                Period = a["Period"].ToString(),
                imgArriveBB = a["imgArriveBB"].ToString(),
                imgLeaveBB = a["imgLeaveBB"].ToString(),
                TaskDate = a["TaskDate"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return activity;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_DriverStatus_PopUp(string cid, string did, string driverID, string date)
    {
        DataTable table = null;
        var activity = new List<DriverStatusModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_DriverStatus_PopUp(cid, did, driverID, date, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new DriverStatusModel
            {
                TaskTime = a["TaskTime"].ToString(),
                ShipmentID = a["ShipmentID"].ToString(),
                Customer = a["Cust"].ToString(),
                CustAddress = a["CustAddress"].ToString(),
                TaskID = a["TaskID"].ToString(),
                DocNumber = a["DocNum"].ToString(),
                ReportCode = a["ReportCode"].ToString(),
                Description = a["Description"].ToString(),
                Comment = a["Comment"].ToString(),
                LastChange = a["LastChange"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_EndDay(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<EndDayModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_EndDay(cid, did, driverID, date, toDate, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new EndDayModel
            {
                ImgStatus = a["imgStatus"].ToString(),
                CountryID = a["CountryID"].ToString(),
                FromDate = a["FromDate"].ToString(),
                DriverID = a["DriverID"].ToString(),
                DriverName = a["DriverName"].ToString(),
                Shipment = a["Shipment"].ToString(),
                Delivery = a["Delivery"].ToString(),
                AgentReturn = a["AgentReturn"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                CollectedSurfaces = a["CollectedSurfaces"].ToString(),
                STYLE_CollectedSurfaces = a["STYLE_CollectedSurfaces"].ToString(),
                DistansePlanned = a["KmPlanned"].ToString(),
                DistanseReal = a["KmActual"].ToString(),
                TaskDate = a["TaskDate"].ToString(),
                EndDayCycle = a["Cycle"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }

    public List<EndDayModel> Layout_POD_WEB_EndDayExcel(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<EndDayModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_EndDay(cid, did, driverID, date, toDate, ConfigurationManager.AppSettings["Diplomat_WebConnectionString"].ToString());
            }
            activity = table.AsEnumerable().Select(a => new EndDayModel
            {
                ImgStatus = a["imgStatus"].ToString(),
                CountryID = a["CountryID"].ToString(),
                FromDate = a["FromDate"].ToString(),
                DriverID = a["DriverID"].ToString(),
                DriverName = a["DriverName"].ToString(),
                Shipment = a["Shipment"].ToString(),
                Delivery = a["Delivery"].ToString(),
                AgentReturn = a["AgentReturn"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                CollectedSurfaces = a["CollectedSurfaces"].ToString(),
                STYLE_CollectedSurfaces = a["STYLE_CollectedSurfaces"].ToString(),
                DistansePlanned = a["KmPlanned"].ToString(),
                DistanseReal = a["KmActual"].ToString(),
                TaskDate = a["TaskDate"].ToString(),
                EndDayCycle = a["Cycle"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return activity;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_EndDay_PopUp(string cid, string did, string driverID, string date, string cycle)
    {
        DataTable table = null;
        var activity = new List<EndDayModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_EndDay_PopUp(cid, did, driverID, date, cycle, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new EndDayModel
            {
                ImgStatus = a["imgStatus"].ToString(),
                DriverName = a["Driver"].ToString(),
                Shipment = a["Shipment"].ToString(),
                Delivery = a["Delivery"].ToString(),
                AgentReturn = a["CustReturns"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                CollectedSurfaces = a["CollectedSurfaces"].ToString(),
                STYLE_CollectedSurfaces = a["STYLE_CollectedSurfaces"].ToString(),
                CustomerAddress = a["CustAddress"].ToString(),
                Status = a["LastStatus"].ToString(),
                CycleDetails = cycle
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }

    public List<CustomerModel> POD_WEB_AgentDailyActivity(string cid, string did, string driverID, string date, string todate) {
        DataTable table = null;
        var activity = new List<CustomerModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_AgentDailyActivity(cid, did, driverID, date, todate, ConfigurationManager.AppSettings["Diplomat_WebConnectionString"].ToString());
            }
            activity = table.AsEnumerable().Select(a => new CustomerModel
            {
                ImgStatus = a["imgStatus"].ToString(),
                Driver = a["Driver"].ToString(),
                Shipment = a["Shipment"].ToString(),
                Delivery = a["Delivery"].ToString(),
                CustReturn = a["CustReturns"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                CollectedSurfaces = a["CollectedSurfaces"].ToString(),
                STYLE_CollectedSurfaces = a["STYLE_CollectedSurfaces"].ToString(),
                STYLE_DriverReturn = a["STYLE_DriverReturn"].ToString(),
                STYLE_ServiceHours = a["STYLE_ServiceHours"].ToString(),
                CustomerAddress = a["CustAddress"].ToString(),
                IdStatus = int.Parse(a["idStatus"].ToString()),
                TravelHours = a["TravelHours"].ToString(),
                ServiceHours = a["ServiceHours"].ToString(),
                OriginalTime = a["OriginalTime"].ToString(),
                DeliveryTime = a["DeliveryTime"].ToString(),
                TaskDate = a["TaskDate"].ToString(),
                Customer = a["Cust"].ToString(),
                CustomerID = a["CustId1"].ToString(),
                DriverID = a["AgentId1"].ToString(),
                DistrID = a["DistrID1"].ToString(),
                ReportGPS_Lat = a["ReportGPS_Lat"].ToString(),
                ReportGPS_Lon = a["ReportGPS_Lon"].ToString(),
                ServiceHoursMinutes = a["ServiceHoursMinutes"].ToString(),
                TravelHoursMinutes = a["TravelHoursMinutes"].ToString(),
                ByTrack = a["ByTrack"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
        return activity;

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_AgentDailyActivity(string cid, string did, string driverID, string date, string todate)
    {
        DataTable table = null;
        var activity = new List<CustomerModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_AgentDailyActivity(cid, did, driverID, date, todate, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new CustomerModel
            {
                ImgStatus = a["imgStatus"].ToString(),
                Driver = a["Driver"].ToString(),
                Shipment = a["Shipment"].ToString(),
                Delivery = a["Delivery"].ToString(),
                CustReturn = a["CustReturns"].ToString(),
                DriverReturn = a["DriverReturn"].ToString(),
                CollectedSurfaces = a["CollectedSurfaces"].ToString(),
                STYLE_CollectedSurfaces = a["STYLE_CollectedSurfaces"].ToString(),
                STYLE_DriverReturn = a["STYLE_DriverReturn"].ToString(),
                STYLE_ServiceHours = a["STYLE_ServiceHours"].ToString(),
                CustomerAddress = a["CustAddress"].ToString(),
                IdStatus = int.Parse(a["idStatus"].ToString()),
                TravelHours = a["TravelHours"].ToString(),
                ServiceHours = a["ServiceHours"].ToString(),
                OriginalTime = a["OriginalTime"].ToString(),
                DeliveryTime = a["DeliveryTime"].ToString(),
                TaskDate = a["TaskDate"].ToString(),
                Customer = a["Cust"].ToString(),
                CustomerID = a["CustId1"].ToString(),
                DriverID = a["AgentId1"].ToString(),
                DistrID = a["DistrID1"].ToString(),
                ReportGPS_Lat = a["ReportGPS_Lat"].ToString(),
                ReportGPS_Lon = a["ReportGPS_Lon"].ToString(),
                ByTrack = a["ByTrack"].ToString(),
                ServiceHoursMinutes = a["ServiceHoursMinutes"].ToString(),
                TravelHoursMinutes = a["TravelHoursMinutes"].ToString(),
                Mission = a["Mission"].ToString(),
                Quality = a["K"].ToString() == "" ? null : (int?)int.Parse(a["K"].ToString()),
                Cycle = a["Cycle"].ToString(),
                SortOrder = a["SortOrder"].ToString(),
                ActualSortOrder = a["ActualSortOrder"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }
     

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_AgentDailyActivityPopup(string cid, string did, string driverID, string date, string custID)
    {
        DataTable table = null;
        var activity = new List<CustomerModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_AgentDailyActivityPopup(cid, did, driverID, date, custID, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new CustomerModel
            {
                ImgStatus = a["imgStatus"].ToString(),
                Driver = a["Driver"].ToString(),
                Shipment = a["Shipment"].ToString(),
                DeliveryNum = a["DeliveryNum"].ToString(),
                TaskDescription = a["TaskDescription"].ToString(),
                Description = a["Description"].ToString(),
                CustomerAddress = a["CustAddress"].ToString(),
                Comment = a["Comment"].ToString(),
                Customer = a["Cust"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_AgentsReport(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<DriverReportModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_AgentsReport(cid, did, driverID, date, toDate, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new DriverReportModel
            {
                CaseQuantity = float.Parse(a["CaseQuantity"].ToString()),
                DriverName = a["Agent"].ToString(),
                ShipmentNumber = long.Parse(a["ShipmentNumber"].ToString()),
                DocDate = a["DocDate"].ToString(),
                DocStartTime = a["DocStartTime"].ToString(),
                Item = a["Item"].ToString(),
                ReasonDescription = a["ReasonDescription"].ToString(),
                OrigCases = float.Parse(a["OrigCases"].ToString()),
                Reference = long.Parse(a["Reference"].ToString()),
                QTY = float.Parse(a["QTY"].ToString()),
                CustomerData = a["Customer"].ToString(),
                ReturnResCode = a["ReturnResCode"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_AgentsReport1(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<NonVisitModel>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_AgentsReport1(cid, did, driverID, date, toDate, GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new NonVisitModel
            {
                TaskDate = a["TaskDate"].ToString(),
                DriverName = a["Driver"].ToString(),
                ShipmentID = long.Parse(a["ShipmentID"].ToString()),
                TaskID = long.Parse(a["TaskID"].ToString()),
                CustomerData = a["Customer"].ToString(),
                Delivery = a["Delivery"].ToString(),
                ReportDescription = a["ReportDescription"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }
[WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string POD_WEB_REPORT_TITLE_TRUCK_AND_TRAILOR_HEADERS()
    {
        DataTable table = null;
        var activity = new List<TruckReportHeaders>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.POD_WEB_REPORT_TITLE_TRUCK_AND_TRAILOR_HEADERS(GetConnectionString);
            }
            activity = table.AsEnumerable().Select(a => new TruckReportHeaders
            {
                idLevel = int.Parse(a["idLevel"].ToString()),
                idObject = a["idObject"].ToString(),
                idParentObject = a["idParentObject"].ToString(),
                ObjectName = a["ObjectName"].ToString(),
                HeaderName = a["HeaderName"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new PagedList(activity, activity.Count, 10, activity.Count == 0 ? 1 : activity.Count));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string POD_WEB_REPORT_TRUCK_AND_TRAILOR_DATA(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.POD_WEB_REPORT_TRUCK_AND_TRAILOR_DATA(cid, did, driverID, date, toDate, GetConnectionString);
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(table);
    }
	
	
    public List<TruckTrailorReport> Layout_POD_WEB_TrucksAndTrailorDataTable(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        var activity = new List<TruckTrailorReport>();
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_TrucksAndTrailorData(cid, did, driverID, date, toDate, ConfigurationManager.AppSettings["Diplomat_WebConnectionString"].ToString());				
            }

            activity = table.AsEnumerable().Select(a => new TruckTrailorReport
            {
                CarNumber = a["CarNumber"].ToString(),
                Distribution = a["Distribution"].ToString(),
                DocNum = a["DocNum"].ToString(),
                DocTime = a["DocTime"].ToString(),
                DriverStatus = a["DriverStatus"].ToString(),
                FileName = a["FileName"].ToString(),
                Name = a["Name"].ToString(),
                TaskDate = a["TaskDate"].ToString(),
                DriverID = a["DriverID"].ToString(),
                DriverName = a["DriverName"].ToString(),
                Description = a["Description"].ToString(),
				DistributionChannel = a["DistributionChannel"].ToString()
            }).ToList();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return activity;
    }
	
	[WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_TrucksAndTrailorData(string cid, string did, string driverID, string date, string toDate)
    {
        DataTable table = null;
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_TrucksAndTrailorData(cid, did, driverID, date, toDate, GetConnectionString);
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(table);
    }
	
	[WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_POD_WEB_TrucksAndTrailorUpData(string docNum)
    {
        DataTable table = null;
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.Layout_POD_WEB_TrucksAndTrailorUpData(docNum, GetConnectionString);
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(table);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string MPLayout_GetInfoWindow(string countryID)
    {
        DataTable table = null;
        try
        {
            using (var service = new MPLayoutService())
            {
                table = service.MPLayout_GetInfoWindow(countryID, GetConnectionString);
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(table);
    }


    //******************************************* Task grid & edition *******************************************

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_Tasks_GetAllTasksAsync(FilterParams inParams)
    {
        if (inParams == null) inParams = new FilterParams();
        return Newtonsoft.Json.JsonConvert.SerializeObject(new TaskService().Layout_GetDriverTasks(inParams, GetConnectionString));
    }

    public IEnumerable<DriverModel> GetAgentsLAsync(FilterParams inParams)
    {
        if (inParams == null) inParams = new FilterParams();
        return new DriverServicecs().GetAgentsL(inParams);
    }

    public IEnumerable<TaskModel> Layout_GetTaskTypesAsync(FilterParams inParams)
    {
        if (inParams == null) inParams = new FilterParams();
        return new TaskService().Layout_GetTaskTypes(inParams);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_SaveTaskAsync(TaskModel param)
    {
        if (param == null) param = new TaskModel();
        param.UserID = int.Parse(SessionUserID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new TaskService().Layout_SaveTask(param, GetConnectionString));
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Layout_DeleteTaskAsync(TaskModel param)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(new TaskService().Layout_DeleteTask(param, GetConnectionString));
    }
}
