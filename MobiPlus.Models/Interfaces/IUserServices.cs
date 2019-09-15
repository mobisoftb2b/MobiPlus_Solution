using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Interfaces
{
    public interface IUserServices<T> where T : class
    {
        Task<T> Authenticate(string userName, string password);
    }
}
