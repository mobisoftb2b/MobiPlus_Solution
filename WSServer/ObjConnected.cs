using System;
using System.Net.Sockets;

namespace WSServer
{
    internal class ObjConnected
    {
        public Socket clientSocket;
        public DateTime dtSession;

        public ObjConnected(Socket cSocket)
        {
            clientSocket = cSocket;
            dtSession = DateTime.Now;
        }

    }
}