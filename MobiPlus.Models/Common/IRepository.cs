using MobiPlus.Models.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Common
{
    public interface IRepository<TOutput, in TInput> : IDisposable where TOutput : class
    {
        Task<TOutput> GetDataByID(TInput param);
        Task<IEnumerable<TOutput>> GetFilteredData(TInput param);
    }
}
