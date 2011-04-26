using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        string RxString;

        public Form1()
        {
            InitializeComponent();
        }

        private void buttonStart_Click(object sender, EventArgs e)
        {
            serialPort1.PortName = textPort.Text;
            serialPort1.BaudRate = 115200;

            serialPort1.Open();
            if (serialPort1.IsOpen)
            {
                buttonStart.Enabled = false;
                buttonStop.Enabled = true;
                textBox1.ReadOnly = false;
            }
        }

        private void buttonStop_Click(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen)
            {
                serialPort1.Close();
                buttonStart.Enabled = true;
                buttonStop.Enabled = false;
                textBox1.ReadOnly = true;
            }

        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (serialPort1.IsOpen) serialPort1.Close();
        }

        private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            // If the port is closed, don't try to send a character.

            if (!serialPort1.IsOpen) return;

            // If the port is Open, declare a char[] array with one element.
            char[] buff = new char[1];

            // Load element 0 with the key character.

            buff[0] = e.KeyChar;

            // Send the one character buffer.
            serialPort1.Write(buff, 0, 1);

            // Set the KeyPress event as handled so the character won't
            // display locally. If you want it to display, omit the next line.
            //e.Handled = true;
        }

        private void DisplayText(object sender, EventArgs e)
        {
            textBox1.AppendText(RxString);
        }

        private void serialPort1_DataReceived
          (object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {
            RxString = serialPort1.ReadExisting();
            this.Invoke(new EventHandler(DisplayText));
        }

        /// <summary>
        /// Used to calculate the Length of the Parameter Data to be sent and inserts it into the
        /// appropriate text box. If ParamData = "", color will be set to yellow to alert user.
        /// Color reset to white upon proper calculation.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonCalcLength_Click(object sender, EventArgs e)
        {
            if (textParamData.Text != "") {
                textParamLength.Text = Convert.ToString(textParamData.Text.Length);
                textParamData.BackColor = Color.White;
            }
            else
                textParamData.BackColor = Color.Yellow;
        }
        /// <summary>
        /// Calculates the Checksum of all data to be sent. Makes sure that no fields are left blank.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonCalcChecksum_Click(object sender, EventArgs e)
        {
            int flag = 1;
            int i;

            #region CheckForEmptyBoxes
            if (textStart.Text == "")
            {
                textStart.BackColor = Color.Yellow;
                flag = 0;
            }
            else
                textStart.BackColor = Color.White;

            if (textClass.Text == "")
            {
                textClass.BackColor = Color.Yellow;
                flag = 0;
            }
            else
                textClass.BackColor = Color.White;

            if (textParamID.Text == "")
            {
                textParamID.BackColor = Color.Yellow;
                flag = 0;
            }
            else
                textParamID.BackColor = Color.White;

            if (textParamLength.Text == "")
            {
                textParamLength.BackColor = Color.Yellow;
                flag = 0;
            }
            else
                textParamLength.BackColor = Color.White;

            if (textParamData.Text == "")
            {
                textParamData.BackColor = Color.Yellow;
                flag = 0;
            }
            else
                textParamData.BackColor = Color.White;

            if (textEnd.Text == "")
            {
                textEnd.BackColor = Color.Yellow;
                flag = 0;
            }
            else
                textEnd.BackColor = Color.White;
            #endregion

            //Calculate checksum
            if (flag == 1)
            {
                //unsigned int 16 bit to allow for overflow
                UInt16 sum = textClass.Text[0];
                //XOR Param ID - 16 bit so it gets two Hex Codes
                sum += textParamID.Text[0];
                sum += textParamID.Text[1];
                //XOR Parameter Length
                for (i = 0; i < textParamLength.Text.Length; i++)
                    sum += textParamLength.Text[i];
                //XOR Parameter Data
                for (i = 0; i < textParamData.Text.Length; i++)
                    sum += textParamData.Text[i];                

                textChecksum.Text = sum.ToString("X2");
            }
            

                
        }
    }
}
