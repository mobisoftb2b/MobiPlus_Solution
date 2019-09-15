using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.GridDefinition
{
    public class GridStyle
    {
        public long? StyleID { get; set; }
        public string StyleName { get; set; }
        public int? FontSize { get; set; }
        public string FontFamily { get; set; }
        public string ForeColor { get; set; }
        public string BackColor { get; set; }
        public bool isBold { get; set; }
        public bool isUnderline { get; set; }
        public bool isBlink { get; set; }
        public bool IsActive { get; set; }
    }
}
