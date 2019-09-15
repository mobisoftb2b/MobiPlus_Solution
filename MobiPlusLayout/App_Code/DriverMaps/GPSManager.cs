using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Device.Location;

/// <summary>
/// Summary description for GPSManager
/// </summary>
public class Point{
    public double Latitude { get; set; }
    public double Longitude { get; set; }

    public Point(double _latutude, double _longitude) {
        Latitude = _latutude;
        Longitude = _longitude;
    }
}
public class GPSManager
{
    public GPSManager()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public double GetDistance( Point p1, Point p2) {
        var sCoord = new GeoCoordinate(p1.Latitude, p1.Longitude);
        var eCoord = new GeoCoordinate(p2.Latitude, p2.Longitude);
        return sCoord.GetDistanceTo(eCoord);
    }

    void RemoveCoordsUpToDistance(List<Customer> customerCoords, int distanceMeters) {
        Customer prevCust = null;
        double distance = 0;
        foreach (Customer cust in customerCoords.ToList())
        {
            if (prevCust != null)
            {
                distance = GetDistance(new Point(Double.Parse(prevCust.Location.Lat), Double.Parse(prevCust.Location.Lng)), new Point(Double.Parse(cust.Location.Lat), Double.Parse(cust.Location.Lng)));
                if (distance < distanceMeters)
                    customerCoords.Remove(cust);
                else
                {
                    cust.Location.DistFromPrev = ((int)Math.Round(distance)).ToString();
                    prevCust = cust;
                }
            }
            else
                prevCust = cust;
        }
    }

    public void ClearCoordinates(List<Customer> customerCoords)
    {
        List<Customer> saveCustomerCoords = customerCoords.GetRange(0, customerCoords.Count);
        RemoveCoordsUpToDistance(customerCoords, 100);
        if (saveCustomerCoords.Count / customerCoords.Count > 5)
        {
            customerCoords = saveCustomerCoords.GetRange(0, saveCustomerCoords.Count);
            RemoveCoordsUpToDistance(customerCoords, 50);
            if (saveCustomerCoords.Count / customerCoords.Count > 5)
            {
                customerCoords = saveCustomerCoords.GetRange(0, saveCustomerCoords.Count);
                RemoveCoordsUpToDistance(customerCoords, 20);
            }

        }

    }

}