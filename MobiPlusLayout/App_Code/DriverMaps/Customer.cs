using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Customer
/// </summary>
public class Customer
{
    public long? CustomerID { get; set; }
    public string CustomerName { get; set; }
    public string Address { get; set; }
    public string Color { get; set; }
    public GPSLocation Location { get; set; }
    public bool? IsNotSupplayAndVisit { get; set; }
    public bool? IsVisit { get; set; }
    public long? AgentCode { get; set; }

}