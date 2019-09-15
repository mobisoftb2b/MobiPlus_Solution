using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Layout
{
   public class LayoutModel
    {
        public TabModel Tabs { get; set; }
        public FormModel Forms { get; set; }
        public ReportModel Report { get; set; }
        public int StartPos_X { get; set; }
        public int StartPos_Y { get; set; }
        public int ContentDimension_X { get; set; }
        public int ContentDimension_Y { get; set; }
        public int? ContentDim_MinWidth { get; set; }
        public int? ContentDim_MaxWidth { get; set; }
        public int? ContentDim_MinHeight { get; set; }
        public int? ContentDim_MaxHeight { get; set; }
        public bool IsVisible { get; set; }
        public bool IsStatic { get; set; }
        public bool isDraggable { get; set; }
        public bool isResizable { get; set; }
    }
}
