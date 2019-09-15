using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Common
{
    public class appConfig
    {
        public static Color[] ColorsPalette
        {
            get
            {
                return new Color[] { Color.FromArgb(78, 131, 239), Color.FromArgb(249, 182, 70), Color.FromArgb(221, 70, 28),
                Color.FromArgb(29, 97, 144), Color.FromArgb(190, 190, 190), Color.FromArgb(36, 58, 105), Color.FromArgb(253, 230, 130),
                Color.FromArgb(47, 150, 219), Color.FromArgb(199, 109, 78), Color.FromArgb(41, 80, 217), Color.FromArgb(83, 97, 128)};
            }
        }

        public struct RightToLeftDirection
        {
            public const string IL = "Hebrew";
            public const string AR = "ar";
        }

        public enum IntervalAutoMode
        {
            FixedCount = 0,
            VariableCount = 1,
        }

    }
}
