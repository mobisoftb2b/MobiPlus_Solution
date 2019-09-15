using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
    public class DriverStatusModel
    {
        public long? DriverID { get; set; }
        public string DriverName { get; set; }
        public string Cycle { get; set; }
        public string UpdateDate { get; set; }
        public string imgLineDownload { get; set; }
        public string STYLE_imgLineDownload { get; set; }
        public string imgWise { get; set; }
        public string STYLE_imgWise { get; set; }
        public string imgToDiplomat { get; set; }
        public string STYLE_imgToDiplomat { get; set; }
        public string imgLineEnded { get; set; }
        public string STYLE_imgLineEnded { get; set; }
        public string LongDistance { get; set; }
        public string Period { get; set; }
        public string imgArriveBB { get; set; }
        public string STYLE_imgArriveBB { get; set; }
        public string imgLeaveBB { get; set; }
        public string STYLE_imgLeaveBB { get; set; }

        /// <summary>
        /// DriverStatusModel Popup
        /// </summary>
        public string TaskTime { get; set; }
        public string ShipmentID { get; set; }
        public string Customer { get; set; }
        public string CustAddress { get; set; }
        public string TaskID { get; set; }
        public long? DocNumber { get; set; }
        public int? ReportCode { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public string LastChange { get; set; }
    }
}
