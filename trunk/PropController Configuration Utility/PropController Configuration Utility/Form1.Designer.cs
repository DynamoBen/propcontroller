namespace WindowsFormsApplication1
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.buttonStart = new System.Windows.Forms.Button();
            this.buttonStop = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.serialPort1 = new System.IO.Ports.SerialPort(this.components);
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.textStart = new System.Windows.Forms.TextBox();
            this.textClass = new System.Windows.Forms.TextBox();
            this.textParamID = new System.Windows.Forms.TextBox();
            this.textParamLength = new System.Windows.Forms.TextBox();
            this.textParamData = new System.Windows.Forms.TextBox();
            this.textChecksum = new System.Windows.Forms.TextBox();
            this.textEnd = new System.Windows.Forms.TextBox();
            this.buttonCalcLength = new System.Windows.Forms.Button();
            this.buttonCalcChecksum = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.label8 = new System.Windows.Forms.Label();
            this.textPort = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // buttonStart
            // 
            this.buttonStart.Location = new System.Drawing.Point(12, 227);
            this.buttonStart.Name = "buttonStart";
            this.buttonStart.Size = new System.Drawing.Size(75, 23);
            this.buttonStart.TabIndex = 0;
            this.buttonStart.Text = "Start";
            this.buttonStart.UseVisualStyleBackColor = true;
            this.buttonStart.Click += new System.EventHandler(this.buttonStart_Click);
            // 
            // buttonStop
            // 
            this.buttonStop.Location = new System.Drawing.Point(197, 227);
            this.buttonStop.Name = "buttonStop";
            this.buttonStop.Size = new System.Drawing.Size(75, 23);
            this.buttonStop.TabIndex = 1;
            this.buttonStop.Text = "Stop";
            this.buttonStop.UseVisualStyleBackColor = true;
            this.buttonStop.Click += new System.EventHandler(this.buttonStop_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(13, 40);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ReadOnly = true;
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBox1.Size = new System.Drawing.Size(259, 181);
            this.textBox1.TabIndex = 2;
            this.textBox1.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textBox1_KeyPress);
            // 
            // serialPort1
            // 
            this.serialPort1.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(this.serialPort1_DataReceived);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(341, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(29, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Start";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(288, 43);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(82, 13);
            this.label2.TabIndex = 4;
            this.label2.Text = "Command Class";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(301, 70);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(69, 13);
            this.label3.TabIndex = 5;
            this.label3.Text = "Parameter ID";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(279, 97);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(91, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "Parameter Length";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(289, 124);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(81, 13);
            this.label5.TabIndex = 7;
            this.label5.Text = "Parameter Data";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(313, 151);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(57, 13);
            this.label6.TabIndex = 8;
            this.label6.Text = "Checksum";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(344, 178);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(26, 13);
            this.label7.TabIndex = 9;
            this.label7.Text = "End";
            // 
            // textStart
            // 
            this.textStart.Location = new System.Drawing.Point(376, 13);
            this.textStart.Name = "textStart";
            this.textStart.Size = new System.Drawing.Size(100, 20);
            this.textStart.TabIndex = 10;
            this.textStart.Text = "FE";
            // 
            // textClass
            // 
            this.textClass.Location = new System.Drawing.Point(376, 40);
            this.textClass.Name = "textClass";
            this.textClass.Size = new System.Drawing.Size(100, 20);
            this.textClass.TabIndex = 11;
            // 
            // textParamID
            // 
            this.textParamID.Location = new System.Drawing.Point(376, 67);
            this.textParamID.Name = "textParamID";
            this.textParamID.Size = new System.Drawing.Size(100, 20);
            this.textParamID.TabIndex = 12;
            // 
            // textParamLength
            // 
            this.textParamLength.Location = new System.Drawing.Point(376, 94);
            this.textParamLength.Name = "textParamLength";
            this.textParamLength.Size = new System.Drawing.Size(100, 20);
            this.textParamLength.TabIndex = 13;
            // 
            // textParamData
            // 
            this.textParamData.Location = new System.Drawing.Point(376, 121);
            this.textParamData.Name = "textParamData";
            this.textParamData.Size = new System.Drawing.Size(100, 20);
            this.textParamData.TabIndex = 14;
            // 
            // textChecksum
            // 
            this.textChecksum.Location = new System.Drawing.Point(376, 148);
            this.textChecksum.Name = "textChecksum";
            this.textChecksum.Size = new System.Drawing.Size(100, 20);
            this.textChecksum.TabIndex = 15;
            // 
            // textEnd
            // 
            this.textEnd.Location = new System.Drawing.Point(376, 175);
            this.textEnd.Name = "textEnd";
            this.textEnd.Size = new System.Drawing.Size(100, 20);
            this.textEnd.TabIndex = 16;
            this.textEnd.Text = "EF";
            // 
            // buttonCalcLength
            // 
            this.buttonCalcLength.Location = new System.Drawing.Point(482, 92);
            this.buttonCalcLength.Name = "buttonCalcLength";
            this.buttonCalcLength.Size = new System.Drawing.Size(75, 23);
            this.buttonCalcLength.TabIndex = 17;
            this.buttonCalcLength.Text = "Calculate";
            this.buttonCalcLength.UseVisualStyleBackColor = true;
            this.buttonCalcLength.Click += new System.EventHandler(this.buttonCalcLength_Click);
            // 
            // buttonCalcChecksum
            // 
            this.buttonCalcChecksum.Location = new System.Drawing.Point(482, 146);
            this.buttonCalcChecksum.Name = "buttonCalcChecksum";
            this.buttonCalcChecksum.Size = new System.Drawing.Size(92, 23);
            this.buttonCalcChecksum.TabIndex = 18;
            this.buttonCalcChecksum.Text = "Calculate-N/A";
            this.buttonCalcChecksum.UseVisualStyleBackColor = true;
            this.buttonCalcChecksum.Click += new System.EventHandler(this.buttonCalcChecksum_Click);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(376, 227);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(123, 23);
            this.button1.TabIndex = 19;
            this.button1.Text = "Send Advanced -N/A";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(12, 9);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(40, 13);
            this.label8.TabIndex = 20;
            this.label8.Text = "PORT:";
            // 
            // textPort
            // 
            this.textPort.Location = new System.Drawing.Point(58, 6);
            this.textPort.Name = "textPort";
            this.textPort.Size = new System.Drawing.Size(100, 20);
            this.textPort.TabIndex = 21;
            this.textPort.Text = "COM#";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(603, 262);
            this.Controls.Add(this.textPort);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.buttonCalcChecksum);
            this.Controls.Add(this.buttonCalcLength);
            this.Controls.Add(this.textEnd);
            this.Controls.Add(this.textChecksum);
            this.Controls.Add(this.textParamData);
            this.Controls.Add(this.textParamLength);
            this.Controls.Add(this.textParamID);
            this.Controls.Add(this.textClass);
            this.Controls.Add(this.textStart);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.buttonStop);
            this.Controls.Add(this.buttonStart);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form1";
            this.Text = "PropController Configuration Utility";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonStart;
        private System.Windows.Forms.Button buttonStop;
        private System.Windows.Forms.TextBox textBox1;
        private System.IO.Ports.SerialPort serialPort1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox textStart;
        private System.Windows.Forms.TextBox textClass;
        private System.Windows.Forms.TextBox textParamID;
        private System.Windows.Forms.TextBox textParamLength;
        private System.Windows.Forms.TextBox textParamData;
        private System.Windows.Forms.TextBox textChecksum;
        private System.Windows.Forms.TextBox textEnd;
        private System.Windows.Forms.Button buttonCalcLength;
        private System.Windows.Forms.Button buttonCalcChecksum;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox textPort;
    }
}

