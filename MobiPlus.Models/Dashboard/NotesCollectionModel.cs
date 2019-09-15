using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
    public class NotesCollectionModel
    {
        public long? AgentID { get; set; }
        public string DriverName { get; set; }
        public string Customer { get; set; }
        public string TaskDescription { get; set; }
        public string DeliveryNum { get; set; }
        public string InvoiceComment { get; set; }
        public string CustomerComment { get; set; }
        public string DeliveryStatus { get; set; }
    }
}
