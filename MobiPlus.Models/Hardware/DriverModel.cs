using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Hardware;

namespace MobiPlus.Models.Hardware
{
    public class DriverModel
    {
        public long? DriverID { get; set; }
        public string DriverName { get; set; }
        public GPSLocation DriverGPSLocation { get; set; }
        public DeviceModel Device { get; set; }
    }
}
