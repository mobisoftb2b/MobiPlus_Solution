using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for GPSLocation
/// </summary>
public class GPSLocation
{
    public long? LocationID { get; set; }
    public string Lat { get; set; }
    public string Lng { get; set; }
    public string ReportGPS_LAT { get; set; }
    public string ReportGPS_Lon { get; set; }
    public string Comment { get; set; }
    public string DistFromPrev { get; set; }

}