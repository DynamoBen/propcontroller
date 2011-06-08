



<!DOCTYPE html>
<html>
<head>
 <link rel="icon" type="image/vnd.microsoft.icon" href="http://www.gstatic.com/codesite/ph/images/phosting.ico">
 
 <script type="text/javascript">
 
 
 
 
 var codesite_token = "68f59d006ed24ca23ddbcf9440ea0c2a";
 
 
 var CS_env = {"token":"68f59d006ed24ca23ddbcf9440ea0c2a","assetHostPath":"http://www.gstatic.com/codesite/ph","domainName":null,"assetVersionPath":"http://www.gstatic.com/codesite/ph/9104208085135278598","projectName":"spinneret-web-server","projectHomeUrl":"/p/spinneret-web-server","absoluteBaseUrl":"http://code.google.com","relativeBaseUrl":"","urlPrefix":"p","loggedInUserEmail":"ben@byaroch.com"};
 </script>
 
 
 <title>Basic_I2C_Driver.spin - 
 spinneret-web-server -
 
 
 Universal firmware for the Spinneret Web Server from Parallax - Google Project Hosting
 </title>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
 <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" >
 
 <meta name="ROBOTS" content="NOARCHIVE">
 
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/9104208085135278598/css/ph_core.css">
 
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/9104208085135278598/css/ph_detail.css" >
 
 
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/9104208085135278598/css/d_sb.css" >
 
 
 
<!--[if IE]>
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/9104208085135278598/css/d_ie.css" >
<![endif]-->
 <style type="text/css">
 .menuIcon.off { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -42px }
 .menuIcon.on { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -28px }
 .menuIcon.down { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 0; }
 
 
 
  tr.inline_comment {
 background: #fff;
 vertical-align: top;
 }
 div.draft, div.published {
 padding: .3em;
 border: 1px solid #999; 
 margin-bottom: .1em;
 font-family: arial, sans-serif;
 max-width: 60em;
 }
 div.draft {
 background: #ffa;
 } 
 div.published {
 background: #e5ecf9;
 }
 div.published .body, div.draft .body {
 padding: .5em .1em .1em .1em;
 max-width: 60em;
 white-space: pre-wrap;
 white-space: -moz-pre-wrap;
 white-space: -pre-wrap;
 white-space: -o-pre-wrap;
 word-wrap: break-word;
 font-size: 1em;
 }
 div.draft .actions {
 margin-left: 1em;
 font-size: 90%;
 }
 div.draft form {
 padding: .5em .5em .5em 0;
 }
 div.draft textarea, div.published textarea {
 width: 95%;
 height: 10em;
 font-family: arial, sans-serif;
 margin-bottom: .5em;
 }

 
 .nocursor, .nocursor td, .cursor_hidden, .cursor_hidden td {
 background-color: white;
 height: 2px;
 }
 .cursor, .cursor td {
 background-color: darkblue;
 height: 2px;
 display: '';
 }
 
 
.list {
 border: 1px solid white;
 border-bottom: 0;
}

 </style>
</head>
<body class="t4">
 <script type="text/javascript">
 var _gaq = _gaq || [];
 _gaq.push(
 ['siteTracker._setAccount', 'UA-18071-1'],
 ['siteTracker._trackPageview']);
 
 (function() {
 var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
 ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
 (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
 })();
 </script>
<div class="headbg">
 <div id="gaia">
 

 <span>
 
 
 <b>ben@byaroch.com</b>
 
 
 | <a href="/u/@UBBXQFVQBBFAVwF%2F/" id="projects-dropdown" onclick="return false;"
 ><u>My favorites</u> <small>&#9660;</small></a>
 | <a href="/u/@UBBXQFVQBBFAVwF%2F/" onclick="_CS_click('/gb/ph/profile');" 
 title="Profile, Updates, and Settings"
 ><u>Profile</u></a>
 | <a href="https://www.google.com/accounts/Logout?continue=http%3A%2F%2Fcode.google.com%2Fp%2Fspinneret-web-server%2Fsource%2Fbrowse%2Ftrunk%2FBasic_I2C_Driver.spin" 
 onclick="_CS_click('/gb/ph/signout');"
 ><u>Sign out</u></a>
 
 </span>

 </div>
 <div class="gbh" style="left: 0pt;"></div>
 <div class="gbh" style="right: 0pt;"></div>
 
 
 <div style="height: 1px"></div>
<!--[if lte IE 7]>
<div style="text-align:center;">
Your version of Internet Explorer is not supported. Try a browser that
contributes to open source, such as <a href="http://www.firefox.com">Firefox</a>,
<a href="http://www.google.com/chrome">Google Chrome</a>, or
<a href="http://code.google.com/chrome/chromeframe/">Google Chrome Frame</a>.
</div>
<![endif]-->




 <table style="padding:0px; margin: 0px 0px 10px 0px; width:100%" cellpadding="0" cellspacing="0">
 <tr style="height: 58px;">
 
 <td id="plogo">
 <a href="/p/spinneret-web-server/">
 
 <img src="http://www.gstatic.com/codesite/ph/images/defaultlogo.png" alt="Logo">
 
 </a>
 </td>
 
 <td style="padding-left: 0.5em">
 
 <div id="pname">
 <a href="/p/spinneret-web-server/">spinneret-web-server</a>
 </div>
 
 <div id="psum">
 <a id="project_summary_link" href="/p/spinneret-web-server/" >Universal firmware for the Spinneret Web Server from Parallax</a>
 
 </div>
 
 
 </td>
 <td style="white-space:nowrap;text-align:right; vertical-align:bottom;">
 
 <form action="/hosting/search">
 <input size="30" name="q" value="" type="text">
 <input type="submit" name="projectsearch" value="Search projects" >
 </form>
 
 </tr>
 </table>

</div>

 
<div id="mt" class="gtb"> 
 <a href="/p/spinneret-web-server/" class="tab ">Project&nbsp;Home</a>
 
 
 
 
 <a href="/p/spinneret-web-server/downloads/list" class="tab ">Downloads</a>
 
 
 
 
 
 <a href="/p/spinneret-web-server/w/list" class="tab ">Wiki</a>
 
 
 
 
 
 <a href="/p/spinneret-web-server/issues/list"
 class="tab ">Issues</a>
 
 
 
 
 
 <a href="/p/spinneret-web-server/source/list"
 class="tab active">Source</a>
 
 
 
 
 
 <div class=gtbc></div>
</div>
<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0" class="st">
 <tr>
 
 
 
 
 
 
 <td class="subt">
 <div class="st2">
 <div class="isf">
 
 
 
 <span class="inst1"><a href="/p/spinneret-web-server/source/checkout">Checkout</a></span> &nbsp;
 <span class="inst2"><a href="/p/spinneret-web-server/source/browse/">Browse</a></span> &nbsp;
 <span class="inst3"><a href="/p/spinneret-web-server/source/list">Changes</a></span> &nbsp;
 
 <form action="http://www.google.com/codesearch" method="get" style="display:inline"
 onsubmit="document.getElementById('codesearchq').value = document.getElementById('origq').value + ' package:http://spinneret-web-server\\.googlecode\\.com'">
 <input type="hidden" name="q" id="codesearchq" value="">
 <input type="text" maxlength="2048" size="38" id="origq" name="origq" value="" title="Google Code Search" style="font-size:92%">&nbsp;<input type="submit" value="Search Trunk" name="btnG" style="font-size:92%">
 
 
 
 </form>
 </div>
</div>

 </td>
 
 
 
 <td align="right" valign="top" class="bevel-right"></td>
 </tr>
</table>


<script type="text/javascript">
 var cancelBubble = false;
 function _go(url) { document.location = url; }
</script>
<div id="maincol"
 
>

 
<!-- IE -->




<div class="expand">
<div id="colcontrol">
<style type="text/css">
 #file_flipper { white-space: nowrap; padding-right: 2em; }
 #file_flipper.hidden { display: none; }
 #file_flipper .pagelink { color: #0000CC; text-decoration: underline; }
 #file_flipper #visiblefiles { padding-left: 0.5em; padding-right: 0.5em; }
</style>
<table id="nav_and_rev" class="list"
 cellpadding="0" cellspacing="0" width="100%">
 <tr>
 
 <td nowrap="nowrap" class="src_crumbs src_nav" width="33%">
 <strong class="src_nav">Source path:&nbsp;</strong>
 <span id="crumb_root">
 
 <a href="/p/spinneret-web-server/source/browse/">svn</a>/&nbsp;</span>
 <span id="crumb_links" class="ifClosed"><a href="/p/spinneret-web-server/source/browse/trunk/">trunk</a><span class="sp">/&nbsp;</span>Basic_I2C_Driver.spin</span>
 
 

 </td>
 
 
 <td nowrap="nowrap" width="33%" align="right">
 <table cellpadding="0" cellspacing="0" style="font-size: 100%"><tr>
 
 
 <td class="flipper"><b>r22</b></td>
 
 </tr></table>
 </td> 
 </tr>
</table>

<div class="fc">
 
 
 
<style type="text/css">
.undermouse span {
 background-image: url(http://www.gstatic.com/codesite/ph/images/comments.gif); }
</style>
<table class="opened" id="review_comment_area"
><tr>
<td id="nums">
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
<pre><table width="100%" id="nums_table_0"><tr id="gr_svn22_1"

><td id="1"><a href="#1">1</a></td></tr
><tr id="gr_svn22_2"

><td id="2"><a href="#2">2</a></td></tr
><tr id="gr_svn22_3"

><td id="3"><a href="#3">3</a></td></tr
><tr id="gr_svn22_4"

><td id="4"><a href="#4">4</a></td></tr
><tr id="gr_svn22_5"

><td id="5"><a href="#5">5</a></td></tr
><tr id="gr_svn22_6"

><td id="6"><a href="#6">6</a></td></tr
><tr id="gr_svn22_7"

><td id="7"><a href="#7">7</a></td></tr
><tr id="gr_svn22_8"

><td id="8"><a href="#8">8</a></td></tr
><tr id="gr_svn22_9"

><td id="9"><a href="#9">9</a></td></tr
><tr id="gr_svn22_10"

><td id="10"><a href="#10">10</a></td></tr
><tr id="gr_svn22_11"

><td id="11"><a href="#11">11</a></td></tr
><tr id="gr_svn22_12"

><td id="12"><a href="#12">12</a></td></tr
><tr id="gr_svn22_13"

><td id="13"><a href="#13">13</a></td></tr
><tr id="gr_svn22_14"

><td id="14"><a href="#14">14</a></td></tr
><tr id="gr_svn22_15"

><td id="15"><a href="#15">15</a></td></tr
><tr id="gr_svn22_16"

><td id="16"><a href="#16">16</a></td></tr
><tr id="gr_svn22_17"

><td id="17"><a href="#17">17</a></td></tr
><tr id="gr_svn22_18"

><td id="18"><a href="#18">18</a></td></tr
><tr id="gr_svn22_19"

><td id="19"><a href="#19">19</a></td></tr
><tr id="gr_svn22_20"

><td id="20"><a href="#20">20</a></td></tr
><tr id="gr_svn22_21"

><td id="21"><a href="#21">21</a></td></tr
><tr id="gr_svn22_22"

><td id="22"><a href="#22">22</a></td></tr
><tr id="gr_svn22_23"

><td id="23"><a href="#23">23</a></td></tr
><tr id="gr_svn22_24"

><td id="24"><a href="#24">24</a></td></tr
><tr id="gr_svn22_25"

><td id="25"><a href="#25">25</a></td></tr
><tr id="gr_svn22_26"

><td id="26"><a href="#26">26</a></td></tr
><tr id="gr_svn22_27"

><td id="27"><a href="#27">27</a></td></tr
><tr id="gr_svn22_28"

><td id="28"><a href="#28">28</a></td></tr
><tr id="gr_svn22_29"

><td id="29"><a href="#29">29</a></td></tr
><tr id="gr_svn22_30"

><td id="30"><a href="#30">30</a></td></tr
><tr id="gr_svn22_31"

><td id="31"><a href="#31">31</a></td></tr
><tr id="gr_svn22_32"

><td id="32"><a href="#32">32</a></td></tr
><tr id="gr_svn22_33"

><td id="33"><a href="#33">33</a></td></tr
><tr id="gr_svn22_34"

><td id="34"><a href="#34">34</a></td></tr
><tr id="gr_svn22_35"

><td id="35"><a href="#35">35</a></td></tr
><tr id="gr_svn22_36"

><td id="36"><a href="#36">36</a></td></tr
><tr id="gr_svn22_37"

><td id="37"><a href="#37">37</a></td></tr
><tr id="gr_svn22_38"

><td id="38"><a href="#38">38</a></td></tr
><tr id="gr_svn22_39"

><td id="39"><a href="#39">39</a></td></tr
><tr id="gr_svn22_40"

><td id="40"><a href="#40">40</a></td></tr
><tr id="gr_svn22_41"

><td id="41"><a href="#41">41</a></td></tr
><tr id="gr_svn22_42"

><td id="42"><a href="#42">42</a></td></tr
><tr id="gr_svn22_43"

><td id="43"><a href="#43">43</a></td></tr
><tr id="gr_svn22_44"

><td id="44"><a href="#44">44</a></td></tr
><tr id="gr_svn22_45"

><td id="45"><a href="#45">45</a></td></tr
><tr id="gr_svn22_46"

><td id="46"><a href="#46">46</a></td></tr
><tr id="gr_svn22_47"

><td id="47"><a href="#47">47</a></td></tr
><tr id="gr_svn22_48"

><td id="48"><a href="#48">48</a></td></tr
><tr id="gr_svn22_49"

><td id="49"><a href="#49">49</a></td></tr
><tr id="gr_svn22_50"

><td id="50"><a href="#50">50</a></td></tr
><tr id="gr_svn22_51"

><td id="51"><a href="#51">51</a></td></tr
><tr id="gr_svn22_52"

><td id="52"><a href="#52">52</a></td></tr
><tr id="gr_svn22_53"

><td id="53"><a href="#53">53</a></td></tr
><tr id="gr_svn22_54"

><td id="54"><a href="#54">54</a></td></tr
><tr id="gr_svn22_55"

><td id="55"><a href="#55">55</a></td></tr
><tr id="gr_svn22_56"

><td id="56"><a href="#56">56</a></td></tr
><tr id="gr_svn22_57"

><td id="57"><a href="#57">57</a></td></tr
><tr id="gr_svn22_58"

><td id="58"><a href="#58">58</a></td></tr
><tr id="gr_svn22_59"

><td id="59"><a href="#59">59</a></td></tr
><tr id="gr_svn22_60"

><td id="60"><a href="#60">60</a></td></tr
><tr id="gr_svn22_61"

><td id="61"><a href="#61">61</a></td></tr
><tr id="gr_svn22_62"

><td id="62"><a href="#62">62</a></td></tr
><tr id="gr_svn22_63"

><td id="63"><a href="#63">63</a></td></tr
><tr id="gr_svn22_64"

><td id="64"><a href="#64">64</a></td></tr
><tr id="gr_svn22_65"

><td id="65"><a href="#65">65</a></td></tr
><tr id="gr_svn22_66"

><td id="66"><a href="#66">66</a></td></tr
><tr id="gr_svn22_67"

><td id="67"><a href="#67">67</a></td></tr
><tr id="gr_svn22_68"

><td id="68"><a href="#68">68</a></td></tr
><tr id="gr_svn22_69"

><td id="69"><a href="#69">69</a></td></tr
><tr id="gr_svn22_70"

><td id="70"><a href="#70">70</a></td></tr
><tr id="gr_svn22_71"

><td id="71"><a href="#71">71</a></td></tr
><tr id="gr_svn22_72"

><td id="72"><a href="#72">72</a></td></tr
><tr id="gr_svn22_73"

><td id="73"><a href="#73">73</a></td></tr
><tr id="gr_svn22_74"

><td id="74"><a href="#74">74</a></td></tr
><tr id="gr_svn22_75"

><td id="75"><a href="#75">75</a></td></tr
><tr id="gr_svn22_76"

><td id="76"><a href="#76">76</a></td></tr
><tr id="gr_svn22_77"

><td id="77"><a href="#77">77</a></td></tr
><tr id="gr_svn22_78"

><td id="78"><a href="#78">78</a></td></tr
><tr id="gr_svn22_79"

><td id="79"><a href="#79">79</a></td></tr
><tr id="gr_svn22_80"

><td id="80"><a href="#80">80</a></td></tr
><tr id="gr_svn22_81"

><td id="81"><a href="#81">81</a></td></tr
><tr id="gr_svn22_82"

><td id="82"><a href="#82">82</a></td></tr
><tr id="gr_svn22_83"

><td id="83"><a href="#83">83</a></td></tr
><tr id="gr_svn22_84"

><td id="84"><a href="#84">84</a></td></tr
><tr id="gr_svn22_85"

><td id="85"><a href="#85">85</a></td></tr
><tr id="gr_svn22_86"

><td id="86"><a href="#86">86</a></td></tr
><tr id="gr_svn22_87"

><td id="87"><a href="#87">87</a></td></tr
><tr id="gr_svn22_88"

><td id="88"><a href="#88">88</a></td></tr
><tr id="gr_svn22_89"

><td id="89"><a href="#89">89</a></td></tr
><tr id="gr_svn22_90"

><td id="90"><a href="#90">90</a></td></tr
><tr id="gr_svn22_91"

><td id="91"><a href="#91">91</a></td></tr
><tr id="gr_svn22_92"

><td id="92"><a href="#92">92</a></td></tr
><tr id="gr_svn22_93"

><td id="93"><a href="#93">93</a></td></tr
><tr id="gr_svn22_94"

><td id="94"><a href="#94">94</a></td></tr
><tr id="gr_svn22_95"

><td id="95"><a href="#95">95</a></td></tr
><tr id="gr_svn22_96"

><td id="96"><a href="#96">96</a></td></tr
><tr id="gr_svn22_97"

><td id="97"><a href="#97">97</a></td></tr
><tr id="gr_svn22_98"

><td id="98"><a href="#98">98</a></td></tr
><tr id="gr_svn22_99"

><td id="99"><a href="#99">99</a></td></tr
><tr id="gr_svn22_100"

><td id="100"><a href="#100">100</a></td></tr
><tr id="gr_svn22_101"

><td id="101"><a href="#101">101</a></td></tr
><tr id="gr_svn22_102"

><td id="102"><a href="#102">102</a></td></tr
><tr id="gr_svn22_103"

><td id="103"><a href="#103">103</a></td></tr
><tr id="gr_svn22_104"

><td id="104"><a href="#104">104</a></td></tr
><tr id="gr_svn22_105"

><td id="105"><a href="#105">105</a></td></tr
><tr id="gr_svn22_106"

><td id="106"><a href="#106">106</a></td></tr
><tr id="gr_svn22_107"

><td id="107"><a href="#107">107</a></td></tr
><tr id="gr_svn22_108"

><td id="108"><a href="#108">108</a></td></tr
><tr id="gr_svn22_109"

><td id="109"><a href="#109">109</a></td></tr
><tr id="gr_svn22_110"

><td id="110"><a href="#110">110</a></td></tr
><tr id="gr_svn22_111"

><td id="111"><a href="#111">111</a></td></tr
><tr id="gr_svn22_112"

><td id="112"><a href="#112">112</a></td></tr
><tr id="gr_svn22_113"

><td id="113"><a href="#113">113</a></td></tr
><tr id="gr_svn22_114"

><td id="114"><a href="#114">114</a></td></tr
><tr id="gr_svn22_115"

><td id="115"><a href="#115">115</a></td></tr
><tr id="gr_svn22_116"

><td id="116"><a href="#116">116</a></td></tr
><tr id="gr_svn22_117"

><td id="117"><a href="#117">117</a></td></tr
><tr id="gr_svn22_118"

><td id="118"><a href="#118">118</a></td></tr
><tr id="gr_svn22_119"

><td id="119"><a href="#119">119</a></td></tr
><tr id="gr_svn22_120"

><td id="120"><a href="#120">120</a></td></tr
><tr id="gr_svn22_121"

><td id="121"><a href="#121">121</a></td></tr
><tr id="gr_svn22_122"

><td id="122"><a href="#122">122</a></td></tr
><tr id="gr_svn22_123"

><td id="123"><a href="#123">123</a></td></tr
><tr id="gr_svn22_124"

><td id="124"><a href="#124">124</a></td></tr
><tr id="gr_svn22_125"

><td id="125"><a href="#125">125</a></td></tr
><tr id="gr_svn22_126"

><td id="126"><a href="#126">126</a></td></tr
><tr id="gr_svn22_127"

><td id="127"><a href="#127">127</a></td></tr
><tr id="gr_svn22_128"

><td id="128"><a href="#128">128</a></td></tr
><tr id="gr_svn22_129"

><td id="129"><a href="#129">129</a></td></tr
><tr id="gr_svn22_130"

><td id="130"><a href="#130">130</a></td></tr
><tr id="gr_svn22_131"

><td id="131"><a href="#131">131</a></td></tr
><tr id="gr_svn22_132"

><td id="132"><a href="#132">132</a></td></tr
><tr id="gr_svn22_133"

><td id="133"><a href="#133">133</a></td></tr
><tr id="gr_svn22_134"

><td id="134"><a href="#134">134</a></td></tr
><tr id="gr_svn22_135"

><td id="135"><a href="#135">135</a></td></tr
><tr id="gr_svn22_136"

><td id="136"><a href="#136">136</a></td></tr
><tr id="gr_svn22_137"

><td id="137"><a href="#137">137</a></td></tr
><tr id="gr_svn22_138"

><td id="138"><a href="#138">138</a></td></tr
><tr id="gr_svn22_139"

><td id="139"><a href="#139">139</a></td></tr
><tr id="gr_svn22_140"

><td id="140"><a href="#140">140</a></td></tr
><tr id="gr_svn22_141"

><td id="141"><a href="#141">141</a></td></tr
><tr id="gr_svn22_142"

><td id="142"><a href="#142">142</a></td></tr
><tr id="gr_svn22_143"

><td id="143"><a href="#143">143</a></td></tr
><tr id="gr_svn22_144"

><td id="144"><a href="#144">144</a></td></tr
><tr id="gr_svn22_145"

><td id="145"><a href="#145">145</a></td></tr
><tr id="gr_svn22_146"

><td id="146"><a href="#146">146</a></td></tr
><tr id="gr_svn22_147"

><td id="147"><a href="#147">147</a></td></tr
><tr id="gr_svn22_148"

><td id="148"><a href="#148">148</a></td></tr
><tr id="gr_svn22_149"

><td id="149"><a href="#149">149</a></td></tr
><tr id="gr_svn22_150"

><td id="150"><a href="#150">150</a></td></tr
><tr id="gr_svn22_151"

><td id="151"><a href="#151">151</a></td></tr
><tr id="gr_svn22_152"

><td id="152"><a href="#152">152</a></td></tr
><tr id="gr_svn22_153"

><td id="153"><a href="#153">153</a></td></tr
><tr id="gr_svn22_154"

><td id="154"><a href="#154">154</a></td></tr
><tr id="gr_svn22_155"

><td id="155"><a href="#155">155</a></td></tr
><tr id="gr_svn22_156"

><td id="156"><a href="#156">156</a></td></tr
><tr id="gr_svn22_157"

><td id="157"><a href="#157">157</a></td></tr
><tr id="gr_svn22_158"

><td id="158"><a href="#158">158</a></td></tr
><tr id="gr_svn22_159"

><td id="159"><a href="#159">159</a></td></tr
><tr id="gr_svn22_160"

><td id="160"><a href="#160">160</a></td></tr
><tr id="gr_svn22_161"

><td id="161"><a href="#161">161</a></td></tr
><tr id="gr_svn22_162"

><td id="162"><a href="#162">162</a></td></tr
><tr id="gr_svn22_163"

><td id="163"><a href="#163">163</a></td></tr
><tr id="gr_svn22_164"

><td id="164"><a href="#164">164</a></td></tr
><tr id="gr_svn22_165"

><td id="165"><a href="#165">165</a></td></tr
><tr id="gr_svn22_166"

><td id="166"><a href="#166">166</a></td></tr
><tr id="gr_svn22_167"

><td id="167"><a href="#167">167</a></td></tr
><tr id="gr_svn22_168"

><td id="168"><a href="#168">168</a></td></tr
><tr id="gr_svn22_169"

><td id="169"><a href="#169">169</a></td></tr
><tr id="gr_svn22_170"

><td id="170"><a href="#170">170</a></td></tr
><tr id="gr_svn22_171"

><td id="171"><a href="#171">171</a></td></tr
><tr id="gr_svn22_172"

><td id="172"><a href="#172">172</a></td></tr
><tr id="gr_svn22_173"

><td id="173"><a href="#173">173</a></td></tr
><tr id="gr_svn22_174"

><td id="174"><a href="#174">174</a></td></tr
><tr id="gr_svn22_175"

><td id="175"><a href="#175">175</a></td></tr
><tr id="gr_svn22_176"

><td id="176"><a href="#176">176</a></td></tr
><tr id="gr_svn22_177"

><td id="177"><a href="#177">177</a></td></tr
><tr id="gr_svn22_178"

><td id="178"><a href="#178">178</a></td></tr
><tr id="gr_svn22_179"

><td id="179"><a href="#179">179</a></td></tr
><tr id="gr_svn22_180"

><td id="180"><a href="#180">180</a></td></tr
><tr id="gr_svn22_181"

><td id="181"><a href="#181">181</a></td></tr
><tr id="gr_svn22_182"

><td id="182"><a href="#182">182</a></td></tr
><tr id="gr_svn22_183"

><td id="183"><a href="#183">183</a></td></tr
><tr id="gr_svn22_184"

><td id="184"><a href="#184">184</a></td></tr
><tr id="gr_svn22_185"

><td id="185"><a href="#185">185</a></td></tr
><tr id="gr_svn22_186"

><td id="186"><a href="#186">186</a></td></tr
><tr id="gr_svn22_187"

><td id="187"><a href="#187">187</a></td></tr
><tr id="gr_svn22_188"

><td id="188"><a href="#188">188</a></td></tr
><tr id="gr_svn22_189"

><td id="189"><a href="#189">189</a></td></tr
><tr id="gr_svn22_190"

><td id="190"><a href="#190">190</a></td></tr
><tr id="gr_svn22_191"

><td id="191"><a href="#191">191</a></td></tr
><tr id="gr_svn22_192"

><td id="192"><a href="#192">192</a></td></tr
><tr id="gr_svn22_193"

><td id="193"><a href="#193">193</a></td></tr
><tr id="gr_svn22_194"

><td id="194"><a href="#194">194</a></td></tr
><tr id="gr_svn22_195"

><td id="195"><a href="#195">195</a></td></tr
><tr id="gr_svn22_196"

><td id="196"><a href="#196">196</a></td></tr
><tr id="gr_svn22_197"

><td id="197"><a href="#197">197</a></td></tr
><tr id="gr_svn22_198"

><td id="198"><a href="#198">198</a></td></tr
><tr id="gr_svn22_199"

><td id="199"><a href="#199">199</a></td></tr
><tr id="gr_svn22_200"

><td id="200"><a href="#200">200</a></td></tr
><tr id="gr_svn22_201"

><td id="201"><a href="#201">201</a></td></tr
><tr id="gr_svn22_202"

><td id="202"><a href="#202">202</a></td></tr
><tr id="gr_svn22_203"

><td id="203"><a href="#203">203</a></td></tr
><tr id="gr_svn22_204"

><td id="204"><a href="#204">204</a></td></tr
><tr id="gr_svn22_205"

><td id="205"><a href="#205">205</a></td></tr
><tr id="gr_svn22_206"

><td id="206"><a href="#206">206</a></td></tr
><tr id="gr_svn22_207"

><td id="207"><a href="#207">207</a></td></tr
><tr id="gr_svn22_208"

><td id="208"><a href="#208">208</a></td></tr
><tr id="gr_svn22_209"

><td id="209"><a href="#209">209</a></td></tr
><tr id="gr_svn22_210"

><td id="210"><a href="#210">210</a></td></tr
><tr id="gr_svn22_211"

><td id="211"><a href="#211">211</a></td></tr
><tr id="gr_svn22_212"

><td id="212"><a href="#212">212</a></td></tr
><tr id="gr_svn22_213"

><td id="213"><a href="#213">213</a></td></tr
><tr id="gr_svn22_214"

><td id="214"><a href="#214">214</a></td></tr
><tr id="gr_svn22_215"

><td id="215"><a href="#215">215</a></td></tr
><tr id="gr_svn22_216"

><td id="216"><a href="#216">216</a></td></tr
><tr id="gr_svn22_217"

><td id="217"><a href="#217">217</a></td></tr
><tr id="gr_svn22_218"

><td id="218"><a href="#218">218</a></td></tr
><tr id="gr_svn22_219"

><td id="219"><a href="#219">219</a></td></tr
><tr id="gr_svn22_220"

><td id="220"><a href="#220">220</a></td></tr
><tr id="gr_svn22_221"

><td id="221"><a href="#221">221</a></td></tr
><tr id="gr_svn22_222"

><td id="222"><a href="#222">222</a></td></tr
><tr id="gr_svn22_223"

><td id="223"><a href="#223">223</a></td></tr
><tr id="gr_svn22_224"

><td id="224"><a href="#224">224</a></td></tr
><tr id="gr_svn22_225"

><td id="225"><a href="#225">225</a></td></tr
><tr id="gr_svn22_226"

><td id="226"><a href="#226">226</a></td></tr
><tr id="gr_svn22_227"

><td id="227"><a href="#227">227</a></td></tr
><tr id="gr_svn22_228"

><td id="228"><a href="#228">228</a></td></tr
><tr id="gr_svn22_229"

><td id="229"><a href="#229">229</a></td></tr
><tr id="gr_svn22_230"

><td id="230"><a href="#230">230</a></td></tr
><tr id="gr_svn22_231"

><td id="231"><a href="#231">231</a></td></tr
><tr id="gr_svn22_232"

><td id="232"><a href="#232">232</a></td></tr
><tr id="gr_svn22_233"

><td id="233"><a href="#233">233</a></td></tr
><tr id="gr_svn22_234"

><td id="234"><a href="#234">234</a></td></tr
><tr id="gr_svn22_235"

><td id="235"><a href="#235">235</a></td></tr
><tr id="gr_svn22_236"

><td id="236"><a href="#236">236</a></td></tr
><tr id="gr_svn22_237"

><td id="237"><a href="#237">237</a></td></tr
><tr id="gr_svn22_238"

><td id="238"><a href="#238">238</a></td></tr
><tr id="gr_svn22_239"

><td id="239"><a href="#239">239</a></td></tr
><tr id="gr_svn22_240"

><td id="240"><a href="#240">240</a></td></tr
><tr id="gr_svn22_241"

><td id="241"><a href="#241">241</a></td></tr
><tr id="gr_svn22_242"

><td id="242"><a href="#242">242</a></td></tr
><tr id="gr_svn22_243"

><td id="243"><a href="#243">243</a></td></tr
><tr id="gr_svn22_244"

><td id="244"><a href="#244">244</a></td></tr
><tr id="gr_svn22_245"

><td id="245"><a href="#245">245</a></td></tr
><tr id="gr_svn22_246"

><td id="246"><a href="#246">246</a></td></tr
><tr id="gr_svn22_247"

><td id="247"><a href="#247">247</a></td></tr
><tr id="gr_svn22_248"

><td id="248"><a href="#248">248</a></td></tr
><tr id="gr_svn22_249"

><td id="249"><a href="#249">249</a></td></tr
><tr id="gr_svn22_250"

><td id="250"><a href="#250">250</a></td></tr
><tr id="gr_svn22_251"

><td id="251"><a href="#251">251</a></td></tr
><tr id="gr_svn22_252"

><td id="252"><a href="#252">252</a></td></tr
><tr id="gr_svn22_253"

><td id="253"><a href="#253">253</a></td></tr
><tr id="gr_svn22_254"

><td id="254"><a href="#254">254</a></td></tr
><tr id="gr_svn22_255"

><td id="255"><a href="#255">255</a></td></tr
><tr id="gr_svn22_256"

><td id="256"><a href="#256">256</a></td></tr
><tr id="gr_svn22_257"

><td id="257"><a href="#257">257</a></td></tr
><tr id="gr_svn22_258"

><td id="258"><a href="#258">258</a></td></tr
><tr id="gr_svn22_259"

><td id="259"><a href="#259">259</a></td></tr
><tr id="gr_svn22_260"

><td id="260"><a href="#260">260</a></td></tr
><tr id="gr_svn22_261"

><td id="261"><a href="#261">261</a></td></tr
><tr id="gr_svn22_262"

><td id="262"><a href="#262">262</a></td></tr
><tr id="gr_svn22_263"

><td id="263"><a href="#263">263</a></td></tr
><tr id="gr_svn22_264"

><td id="264"><a href="#264">264</a></td></tr
><tr id="gr_svn22_265"

><td id="265"><a href="#265">265</a></td></tr
><tr id="gr_svn22_266"

><td id="266"><a href="#266">266</a></td></tr
><tr id="gr_svn22_267"

><td id="267"><a href="#267">267</a></td></tr
><tr id="gr_svn22_268"

><td id="268"><a href="#268">268</a></td></tr
><tr id="gr_svn22_269"

><td id="269"><a href="#269">269</a></td></tr
><tr id="gr_svn22_270"

><td id="270"><a href="#270">270</a></td></tr
><tr id="gr_svn22_271"

><td id="271"><a href="#271">271</a></td></tr
><tr id="gr_svn22_272"

><td id="272"><a href="#272">272</a></td></tr
><tr id="gr_svn22_273"

><td id="273"><a href="#273">273</a></td></tr
><tr id="gr_svn22_274"

><td id="274"><a href="#274">274</a></td></tr
><tr id="gr_svn22_275"

><td id="275"><a href="#275">275</a></td></tr
><tr id="gr_svn22_276"

><td id="276"><a href="#276">276</a></td></tr
><tr id="gr_svn22_277"

><td id="277"><a href="#277">277</a></td></tr
><tr id="gr_svn22_278"

><td id="278"><a href="#278">278</a></td></tr
><tr id="gr_svn22_279"

><td id="279"><a href="#279">279</a></td></tr
><tr id="gr_svn22_280"

><td id="280"><a href="#280">280</a></td></tr
><tr id="gr_svn22_281"

><td id="281"><a href="#281">281</a></td></tr
><tr id="gr_svn22_282"

><td id="282"><a href="#282">282</a></td></tr
><tr id="gr_svn22_283"

><td id="283"><a href="#283">283</a></td></tr
><tr id="gr_svn22_284"

><td id="284"><a href="#284">284</a></td></tr
><tr id="gr_svn22_285"

><td id="285"><a href="#285">285</a></td></tr
><tr id="gr_svn22_286"

><td id="286"><a href="#286">286</a></td></tr
><tr id="gr_svn22_287"

><td id="287"><a href="#287">287</a></td></tr
><tr id="gr_svn22_288"

><td id="288"><a href="#288">288</a></td></tr
><tr id="gr_svn22_289"

><td id="289"><a href="#289">289</a></td></tr
><tr id="gr_svn22_290"

><td id="290"><a href="#290">290</a></td></tr
><tr id="gr_svn22_291"

><td id="291"><a href="#291">291</a></td></tr
><tr id="gr_svn22_292"

><td id="292"><a href="#292">292</a></td></tr
><tr id="gr_svn22_293"

><td id="293"><a href="#293">293</a></td></tr
><tr id="gr_svn22_294"

><td id="294"><a href="#294">294</a></td></tr
><tr id="gr_svn22_295"

><td id="295"><a href="#295">295</a></td></tr
><tr id="gr_svn22_296"

><td id="296"><a href="#296">296</a></td></tr
><tr id="gr_svn22_297"

><td id="297"><a href="#297">297</a></td></tr
><tr id="gr_svn22_298"

><td id="298"><a href="#298">298</a></td></tr
><tr id="gr_svn22_299"

><td id="299"><a href="#299">299</a></td></tr
><tr id="gr_svn22_300"

><td id="300"><a href="#300">300</a></td></tr
><tr id="gr_svn22_301"

><td id="301"><a href="#301">301</a></td></tr
><tr id="gr_svn22_302"

><td id="302"><a href="#302">302</a></td></tr
><tr id="gr_svn22_303"

><td id="303"><a href="#303">303</a></td></tr
><tr id="gr_svn22_304"

><td id="304"><a href="#304">304</a></td></tr
><tr id="gr_svn22_305"

><td id="305"><a href="#305">305</a></td></tr
><tr id="gr_svn22_306"

><td id="306"><a href="#306">306</a></td></tr
><tr id="gr_svn22_307"

><td id="307"><a href="#307">307</a></td></tr
><tr id="gr_svn22_308"

><td id="308"><a href="#308">308</a></td></tr
><tr id="gr_svn22_309"

><td id="309"><a href="#309">309</a></td></tr
><tr id="gr_svn22_310"

><td id="310"><a href="#310">310</a></td></tr
><tr id="gr_svn22_311"

><td id="311"><a href="#311">311</a></td></tr
><tr id="gr_svn22_312"

><td id="312"><a href="#312">312</a></td></tr
><tr id="gr_svn22_313"

><td id="313"><a href="#313">313</a></td></tr
><tr id="gr_svn22_314"

><td id="314"><a href="#314">314</a></td></tr
><tr id="gr_svn22_315"

><td id="315"><a href="#315">315</a></td></tr
><tr id="gr_svn22_316"

><td id="316"><a href="#316">316</a></td></tr
><tr id="gr_svn22_317"

><td id="317"><a href="#317">317</a></td></tr
><tr id="gr_svn22_318"

><td id="318"><a href="#318">318</a></td></tr
><tr id="gr_svn22_319"

><td id="319"><a href="#319">319</a></td></tr
><tr id="gr_svn22_320"

><td id="320"><a href="#320">320</a></td></tr
><tr id="gr_svn22_321"

><td id="321"><a href="#321">321</a></td></tr
><tr id="gr_svn22_322"

><td id="322"><a href="#322">322</a></td></tr
><tr id="gr_svn22_323"

><td id="323"><a href="#323">323</a></td></tr
><tr id="gr_svn22_324"

><td id="324"><a href="#324">324</a></td></tr
><tr id="gr_svn22_325"

><td id="325"><a href="#325">325</a></td></tr
><tr id="gr_svn22_326"

><td id="326"><a href="#326">326</a></td></tr
><tr id="gr_svn22_327"

><td id="327"><a href="#327">327</a></td></tr
><tr id="gr_svn22_328"

><td id="328"><a href="#328">328</a></td></tr
><tr id="gr_svn22_329"

><td id="329"><a href="#329">329</a></td></tr
><tr id="gr_svn22_330"

><td id="330"><a href="#330">330</a></td></tr
><tr id="gr_svn22_331"

><td id="331"><a href="#331">331</a></td></tr
><tr id="gr_svn22_332"

><td id="332"><a href="#332">332</a></td></tr
><tr id="gr_svn22_333"

><td id="333"><a href="#333">333</a></td></tr
><tr id="gr_svn22_334"

><td id="334"><a href="#334">334</a></td></tr
><tr id="gr_svn22_335"

><td id="335"><a href="#335">335</a></td></tr
><tr id="gr_svn22_336"

><td id="336"><a href="#336">336</a></td></tr
><tr id="gr_svn22_337"

><td id="337"><a href="#337">337</a></td></tr
><tr id="gr_svn22_338"

><td id="338"><a href="#338">338</a></td></tr
><tr id="gr_svn22_339"

><td id="339"><a href="#339">339</a></td></tr
><tr id="gr_svn22_340"

><td id="340"><a href="#340">340</a></td></tr
><tr id="gr_svn22_341"

><td id="341"><a href="#341">341</a></td></tr
><tr id="gr_svn22_342"

><td id="342"><a href="#342">342</a></td></tr
><tr id="gr_svn22_343"

><td id="343"><a href="#343">343</a></td></tr
><tr id="gr_svn22_344"

><td id="344"><a href="#344">344</a></td></tr
><tr id="gr_svn22_345"

><td id="345"><a href="#345">345</a></td></tr
><tr id="gr_svn22_346"

><td id="346"><a href="#346">346</a></td></tr
><tr id="gr_svn22_347"

><td id="347"><a href="#347">347</a></td></tr
><tr id="gr_svn22_348"

><td id="348"><a href="#348">348</a></td></tr
><tr id="gr_svn22_349"

><td id="349"><a href="#349">349</a></td></tr
><tr id="gr_svn22_350"

><td id="350"><a href="#350">350</a></td></tr
><tr id="gr_svn22_351"

><td id="351"><a href="#351">351</a></td></tr
><tr id="gr_svn22_352"

><td id="352"><a href="#352">352</a></td></tr
><tr id="gr_svn22_353"

><td id="353"><a href="#353">353</a></td></tr
><tr id="gr_svn22_354"

><td id="354"><a href="#354">354</a></td></tr
><tr id="gr_svn22_355"

><td id="355"><a href="#355">355</a></td></tr
><tr id="gr_svn22_356"

><td id="356"><a href="#356">356</a></td></tr
><tr id="gr_svn22_357"

><td id="357"><a href="#357">357</a></td></tr
><tr id="gr_svn22_358"

><td id="358"><a href="#358">358</a></td></tr
><tr id="gr_svn22_359"

><td id="359"><a href="#359">359</a></td></tr
><tr id="gr_svn22_360"

><td id="360"><a href="#360">360</a></td></tr
><tr id="gr_svn22_361"

><td id="361"><a href="#361">361</a></td></tr
><tr id="gr_svn22_362"

><td id="362"><a href="#362">362</a></td></tr
><tr id="gr_svn22_363"

><td id="363"><a href="#363">363</a></td></tr
><tr id="gr_svn22_364"

><td id="364"><a href="#364">364</a></td></tr
><tr id="gr_svn22_365"

><td id="365"><a href="#365">365</a></td></tr
><tr id="gr_svn22_366"

><td id="366"><a href="#366">366</a></td></tr
><tr id="gr_svn22_367"

><td id="367"><a href="#367">367</a></td></tr
><tr id="gr_svn22_368"

><td id="368"><a href="#368">368</a></td></tr
><tr id="gr_svn22_369"

><td id="369"><a href="#369">369</a></td></tr
><tr id="gr_svn22_370"

><td id="370"><a href="#370">370</a></td></tr
><tr id="gr_svn22_371"

><td id="371"><a href="#371">371</a></td></tr
><tr id="gr_svn22_372"

><td id="372"><a href="#372">372</a></td></tr
><tr id="gr_svn22_373"

><td id="373"><a href="#373">373</a></td></tr
><tr id="gr_svn22_374"

><td id="374"><a href="#374">374</a></td></tr
><tr id="gr_svn22_375"

><td id="375"><a href="#375">375</a></td></tr
><tr id="gr_svn22_376"

><td id="376"><a href="#376">376</a></td></tr
><tr id="gr_svn22_377"

><td id="377"><a href="#377">377</a></td></tr
><tr id="gr_svn22_378"

><td id="378"><a href="#378">378</a></td></tr
><tr id="gr_svn22_379"

><td id="379"><a href="#379">379</a></td></tr
><tr id="gr_svn22_380"

><td id="380"><a href="#380">380</a></td></tr
><tr id="gr_svn22_381"

><td id="381"><a href="#381">381</a></td></tr
><tr id="gr_svn22_382"

><td id="382"><a href="#382">382</a></td></tr
><tr id="gr_svn22_383"

><td id="383"><a href="#383">383</a></td></tr
><tr id="gr_svn22_384"

><td id="384"><a href="#384">384</a></td></tr
><tr id="gr_svn22_385"

><td id="385"><a href="#385">385</a></td></tr
><tr id="gr_svn22_386"

><td id="386"><a href="#386">386</a></td></tr
><tr id="gr_svn22_387"

><td id="387"><a href="#387">387</a></td></tr
><tr id="gr_svn22_388"

><td id="388"><a href="#388">388</a></td></tr
><tr id="gr_svn22_389"

><td id="389"><a href="#389">389</a></td></tr
><tr id="gr_svn22_390"

><td id="390"><a href="#390">390</a></td></tr
><tr id="gr_svn22_391"

><td id="391"><a href="#391">391</a></td></tr
><tr id="gr_svn22_392"

><td id="392"><a href="#392">392</a></td></tr
><tr id="gr_svn22_393"

><td id="393"><a href="#393">393</a></td></tr
><tr id="gr_svn22_394"

><td id="394"><a href="#394">394</a></td></tr
><tr id="gr_svn22_395"

><td id="395"><a href="#395">395</a></td></tr
><tr id="gr_svn22_396"

><td id="396"><a href="#396">396</a></td></tr
><tr id="gr_svn22_397"

><td id="397"><a href="#397">397</a></td></tr
><tr id="gr_svn22_398"

><td id="398"><a href="#398">398</a></td></tr
><tr id="gr_svn22_399"

><td id="399"><a href="#399">399</a></td></tr
><tr id="gr_svn22_400"

><td id="400"><a href="#400">400</a></td></tr
><tr id="gr_svn22_401"

><td id="401"><a href="#401">401</a></td></tr
><tr id="gr_svn22_402"

><td id="402"><a href="#402">402</a></td></tr
><tr id="gr_svn22_403"

><td id="403"><a href="#403">403</a></td></tr
><tr id="gr_svn22_404"

><td id="404"><a href="#404">404</a></td></tr
><tr id="gr_svn22_405"

><td id="405"><a href="#405">405</a></td></tr
><tr id="gr_svn22_406"

><td id="406"><a href="#406">406</a></td></tr
><tr id="gr_svn22_407"

><td id="407"><a href="#407">407</a></td></tr
><tr id="gr_svn22_408"

><td id="408"><a href="#408">408</a></td></tr
><tr id="gr_svn22_409"

><td id="409"><a href="#409">409</a></td></tr
><tr id="gr_svn22_410"

><td id="410"><a href="#410">410</a></td></tr
><tr id="gr_svn22_411"

><td id="411"><a href="#411">411</a></td></tr
><tr id="gr_svn22_412"

><td id="412"><a href="#412">412</a></td></tr
><tr id="gr_svn22_413"

><td id="413"><a href="#413">413</a></td></tr
><tr id="gr_svn22_414"

><td id="414"><a href="#414">414</a></td></tr
><tr id="gr_svn22_415"

><td id="415"><a href="#415">415</a></td></tr
><tr id="gr_svn22_416"

><td id="416"><a href="#416">416</a></td></tr
><tr id="gr_svn22_417"

><td id="417"><a href="#417">417</a></td></tr
><tr id="gr_svn22_418"

><td id="418"><a href="#418">418</a></td></tr
><tr id="gr_svn22_419"

><td id="419"><a href="#419">419</a></td></tr
><tr id="gr_svn22_420"

><td id="420"><a href="#420">420</a></td></tr
><tr id="gr_svn22_421"

><td id="421"><a href="#421">421</a></td></tr
><tr id="gr_svn22_422"

><td id="422"><a href="#422">422</a></td></tr
><tr id="gr_svn22_423"

><td id="423"><a href="#423">423</a></td></tr
><tr id="gr_svn22_424"

><td id="424"><a href="#424">424</a></td></tr
><tr id="gr_svn22_425"

><td id="425"><a href="#425">425</a></td></tr
><tr id="gr_svn22_426"

><td id="426"><a href="#426">426</a></td></tr
><tr id="gr_svn22_427"

><td id="427"><a href="#427">427</a></td></tr
><tr id="gr_svn22_428"

><td id="428"><a href="#428">428</a></td></tr
><tr id="gr_svn22_429"

><td id="429"><a href="#429">429</a></td></tr
><tr id="gr_svn22_430"

><td id="430"><a href="#430">430</a></td></tr
><tr id="gr_svn22_431"

><td id="431"><a href="#431">431</a></td></tr
><tr id="gr_svn22_432"

><td id="432"><a href="#432">432</a></td></tr
><tr id="gr_svn22_433"

><td id="433"><a href="#433">433</a></td></tr
><tr id="gr_svn22_434"

><td id="434"><a href="#434">434</a></td></tr
><tr id="gr_svn22_435"

><td id="435"><a href="#435">435</a></td></tr
><tr id="gr_svn22_436"

><td id="436"><a href="#436">436</a></td></tr
><tr id="gr_svn22_437"

><td id="437"><a href="#437">437</a></td></tr
><tr id="gr_svn22_438"

><td id="438"><a href="#438">438</a></td></tr
><tr id="gr_svn22_439"

><td id="439"><a href="#439">439</a></td></tr
><tr id="gr_svn22_440"

><td id="440"><a href="#440">440</a></td></tr
><tr id="gr_svn22_441"

><td id="441"><a href="#441">441</a></td></tr
><tr id="gr_svn22_442"

><td id="442"><a href="#442">442</a></td></tr
><tr id="gr_svn22_443"

><td id="443"><a href="#443">443</a></td></tr
><tr id="gr_svn22_444"

><td id="444"><a href="#444">444</a></td></tr
><tr id="gr_svn22_445"

><td id="445"><a href="#445">445</a></td></tr
><tr id="gr_svn22_446"

><td id="446"><a href="#446">446</a></td></tr
><tr id="gr_svn22_447"

><td id="447"><a href="#447">447</a></td></tr
><tr id="gr_svn22_448"

><td id="448"><a href="#448">448</a></td></tr
><tr id="gr_svn22_449"

><td id="449"><a href="#449">449</a></td></tr
><tr id="gr_svn22_450"

><td id="450"><a href="#450">450</a></td></tr
><tr id="gr_svn22_451"

><td id="451"><a href="#451">451</a></td></tr
><tr id="gr_svn22_452"

><td id="452"><a href="#452">452</a></td></tr
><tr id="gr_svn22_453"

><td id="453"><a href="#453">453</a></td></tr
><tr id="gr_svn22_454"

><td id="454"><a href="#454">454</a></td></tr
><tr id="gr_svn22_455"

><td id="455"><a href="#455">455</a></td></tr
><tr id="gr_svn22_456"

><td id="456"><a href="#456">456</a></td></tr
><tr id="gr_svn22_457"

><td id="457"><a href="#457">457</a></td></tr
><tr id="gr_svn22_458"

><td id="458"><a href="#458">458</a></td></tr
><tr id="gr_svn22_459"

><td id="459"><a href="#459">459</a></td></tr
><tr id="gr_svn22_460"

><td id="460"><a href="#460">460</a></td></tr
><tr id="gr_svn22_461"

><td id="461"><a href="#461">461</a></td></tr
><tr id="gr_svn22_462"

><td id="462"><a href="#462">462</a></td></tr
><tr id="gr_svn22_463"

><td id="463"><a href="#463">463</a></td></tr
><tr id="gr_svn22_464"

><td id="464"><a href="#464">464</a></td></tr
><tr id="gr_svn22_465"

><td id="465"><a href="#465">465</a></td></tr
><tr id="gr_svn22_466"

><td id="466"><a href="#466">466</a></td></tr
><tr id="gr_svn22_467"

><td id="467"><a href="#467">467</a></td></tr
><tr id="gr_svn22_468"

><td id="468"><a href="#468">468</a></td></tr
><tr id="gr_svn22_469"

><td id="469"><a href="#469">469</a></td></tr
><tr id="gr_svn22_470"

><td id="470"><a href="#470">470</a></td></tr
><tr id="gr_svn22_471"

><td id="471"><a href="#471">471</a></td></tr
><tr id="gr_svn22_472"

><td id="472"><a href="#472">472</a></td></tr
><tr id="gr_svn22_473"

><td id="473"><a href="#473">473</a></td></tr
><tr id="gr_svn22_474"

><td id="474"><a href="#474">474</a></td></tr
><tr id="gr_svn22_475"

><td id="475"><a href="#475">475</a></td></tr
><tr id="gr_svn22_476"

><td id="476"><a href="#476">476</a></td></tr
><tr id="gr_svn22_477"

><td id="477"><a href="#477">477</a></td></tr
><tr id="gr_svn22_478"

><td id="478"><a href="#478">478</a></td></tr
><tr id="gr_svn22_479"

><td id="479"><a href="#479">479</a></td></tr
><tr id="gr_svn22_480"

><td id="480"><a href="#480">480</a></td></tr
><tr id="gr_svn22_481"

><td id="481"><a href="#481">481</a></td></tr
><tr id="gr_svn22_482"

><td id="482"><a href="#482">482</a></td></tr
><tr id="gr_svn22_483"

><td id="483"><a href="#483">483</a></td></tr
><tr id="gr_svn22_484"

><td id="484"><a href="#484">484</a></td></tr
><tr id="gr_svn22_485"

><td id="485"><a href="#485">485</a></td></tr
><tr id="gr_svn22_486"

><td id="486"><a href="#486">486</a></td></tr
><tr id="gr_svn22_487"

><td id="487"><a href="#487">487</a></td></tr
><tr id="gr_svn22_488"

><td id="488"><a href="#488">488</a></td></tr
><tr id="gr_svn22_489"

><td id="489"><a href="#489">489</a></td></tr
><tr id="gr_svn22_490"

><td id="490"><a href="#490">490</a></td></tr
><tr id="gr_svn22_491"

><td id="491"><a href="#491">491</a></td></tr
><tr id="gr_svn22_492"

><td id="492"><a href="#492">492</a></td></tr
><tr id="gr_svn22_493"

><td id="493"><a href="#493">493</a></td></tr
><tr id="gr_svn22_494"

><td id="494"><a href="#494">494</a></td></tr
><tr id="gr_svn22_495"

><td id="495"><a href="#495">495</a></td></tr
><tr id="gr_svn22_496"

><td id="496"><a href="#496">496</a></td></tr
><tr id="gr_svn22_497"

><td id="497"><a href="#497">497</a></td></tr
><tr id="gr_svn22_498"

><td id="498"><a href="#498">498</a></td></tr
><tr id="gr_svn22_499"

><td id="499"><a href="#499">499</a></td></tr
><tr id="gr_svn22_500"

><td id="500"><a href="#500">500</a></td></tr
><tr id="gr_svn22_501"

><td id="501"><a href="#501">501</a></td></tr
><tr id="gr_svn22_502"

><td id="502"><a href="#502">502</a></td></tr
><tr id="gr_svn22_503"

><td id="503"><a href="#503">503</a></td></tr
><tr id="gr_svn22_504"

><td id="504"><a href="#504">504</a></td></tr
><tr id="gr_svn22_505"

><td id="505"><a href="#505">505</a></td></tr
><tr id="gr_svn22_506"

><td id="506"><a href="#506">506</a></td></tr
><tr id="gr_svn22_507"

><td id="507"><a href="#507">507</a></td></tr
><tr id="gr_svn22_508"

><td id="508"><a href="#508">508</a></td></tr
><tr id="gr_svn22_509"

><td id="509"><a href="#509">509</a></td></tr
><tr id="gr_svn22_510"

><td id="510"><a href="#510">510</a></td></tr
><tr id="gr_svn22_511"

><td id="511"><a href="#511">511</a></td></tr
><tr id="gr_svn22_512"

><td id="512"><a href="#512">512</a></td></tr
><tr id="gr_svn22_513"

><td id="513"><a href="#513">513</a></td></tr
><tr id="gr_svn22_514"

><td id="514"><a href="#514">514</a></td></tr
><tr id="gr_svn22_515"

><td id="515"><a href="#515">515</a></td></tr
><tr id="gr_svn22_516"

><td id="516"><a href="#516">516</a></td></tr
><tr id="gr_svn22_517"

><td id="517"><a href="#517">517</a></td></tr
><tr id="gr_svn22_518"

><td id="518"><a href="#518">518</a></td></tr
><tr id="gr_svn22_519"

><td id="519"><a href="#519">519</a></td></tr
><tr id="gr_svn22_520"

><td id="520"><a href="#520">520</a></td></tr
><tr id="gr_svn22_521"

><td id="521"><a href="#521">521</a></td></tr
><tr id="gr_svn22_522"

><td id="522"><a href="#522">522</a></td></tr
><tr id="gr_svn22_523"

><td id="523"><a href="#523">523</a></td></tr
><tr id="gr_svn22_524"

><td id="524"><a href="#524">524</a></td></tr
><tr id="gr_svn22_525"

><td id="525"><a href="#525">525</a></td></tr
><tr id="gr_svn22_526"

><td id="526"><a href="#526">526</a></td></tr
><tr id="gr_svn22_527"

><td id="527"><a href="#527">527</a></td></tr
><tr id="gr_svn22_528"

><td id="528"><a href="#528">528</a></td></tr
><tr id="gr_svn22_529"

><td id="529"><a href="#529">529</a></td></tr
><tr id="gr_svn22_530"

><td id="530"><a href="#530">530</a></td></tr
><tr id="gr_svn22_531"

><td id="531"><a href="#531">531</a></td></tr
><tr id="gr_svn22_532"

><td id="532"><a href="#532">532</a></td></tr
><tr id="gr_svn22_533"

><td id="533"><a href="#533">533</a></td></tr
><tr id="gr_svn22_534"

><td id="534"><a href="#534">534</a></td></tr
><tr id="gr_svn22_535"

><td id="535"><a href="#535">535</a></td></tr
><tr id="gr_svn22_536"

><td id="536"><a href="#536">536</a></td></tr
><tr id="gr_svn22_537"

><td id="537"><a href="#537">537</a></td></tr
><tr id="gr_svn22_538"

><td id="538"><a href="#538">538</a></td></tr
><tr id="gr_svn22_539"

><td id="539"><a href="#539">539</a></td></tr
><tr id="gr_svn22_540"

><td id="540"><a href="#540">540</a></td></tr
><tr id="gr_svn22_541"

><td id="541"><a href="#541">541</a></td></tr
><tr id="gr_svn22_542"

><td id="542"><a href="#542">542</a></td></tr
><tr id="gr_svn22_543"

><td id="543"><a href="#543">543</a></td></tr
></table></pre>
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
</td>
<td id="lines">
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
<pre ><table id="src_table_0"><tr
id=sl_svn22_1

><td class="source">ÿþ&#39; &#39;   B a s i c   I 2 C   R o u t i n e s     V e r s i o n   1 . 1 <br></td></tr
><tr
id=sl_svn22_2

><td class="source"> <br></td></tr
><tr
id=sl_svn22_3

><td class="source"> &#39; &#39;   W r i t t e n   b y   M i c h a e l   G r e e n   a n d   c o p y r i g h t   ( ýÿ)   2 0 0 7 <br></td></tr
><tr
id=sl_svn22_4

><td class="source"> <br></td></tr
><tr
id=sl_svn22_5

><td class="source"> &#39; &#39;   P e r m i s s i o n   i s   g i v e n   t o   u s e   t h i s   i n   a n y   p r o g r a m   f o r   t h e   P a r a l l a x <br></td></tr
><tr
id=sl_svn22_6

><td class="source"> <br></td></tr
><tr
id=sl_svn22_7

><td class="source"> &#39; &#39;   P r o p e l l e r   p r o c e s s o r   a s   l o n g   a s   t h i s   c o p y r i g h t   n o t i c e   i s   i n c l u d e d . <br></td></tr
><tr
id=sl_svn22_8

><td class="source"> <br></td></tr
><tr
id=sl_svn22_9

><td class="source"> <br></td></tr
><tr
id=sl_svn22_10

><td class="source"> <br></td></tr
><tr
id=sl_svn22_11

><td class="source"> &#39; &#39;   T h i s   i s   a   m i n i m a l   v e r s i o n   o f   a n   I 2 C   d r i v e r   i n   S P I N .     I t   a s s u m e s <br></td></tr
><tr
id=sl_svn22_12

><td class="source"> <br></td></tr
><tr
id=sl_svn22_13

><td class="source"> &#39; &#39;   t h a t   t h e   S D A   p i n   i s   o n e   h i g h e r   t h a n   t h e   S C L   p i n .     I t   a s s u m e s   t h a t <br></td></tr
><tr
id=sl_svn22_14

><td class="source"> <br></td></tr
><tr
id=sl_svn22_15

><td class="source"> &#39; &#39;   n e i t h e r   t h e   S D A   n o r   t h e   S C L   p i n s   h a v e   p u l l u p s ,   s o   d r i v e s   b o t h . <br></td></tr
><tr
id=sl_svn22_16

><td class="source"> <br></td></tr
><tr
id=sl_svn22_17

><td class="source"> <br></td></tr
><tr
id=sl_svn22_18

><td class="source"> <br></td></tr
><tr
id=sl_svn22_19

><td class="source"> &#39; &#39;   T h e s e   r o u t i n e s   a r e   p r i m a r i l y   i n t e n d e d   f o r   r e a d i n g   a n d   w r i t i n g   E E P R O M s . <br></td></tr
><tr
id=sl_svn22_20

><td class="source"> <br></td></tr
><tr
id=sl_svn22_21

><td class="source"> &#39; &#39;   T h e   l o w   l e v e l   I 2 C   a r e   p r o v i d e d   f o r   u s e   w i t h   o t h e r   d e v i c e s ,   b u t   t h e <br></td></tr
><tr
id=sl_svn22_22

><td class="source"> <br></td></tr
><tr
id=sl_svn22_23

><td class="source"> &#39; &#39;   r e a d / w r i t e   b y t e   r o u t i n e s   a s s u m e   a   s t a n d a r d   I 2 C   s e r i a l   E E P R O M   w i t h   a <br></td></tr
><tr
id=sl_svn22_24

><td class="source"> <br></td></tr
><tr
id=sl_svn22_25

><td class="source"> &#39; &#39;   1 6   b i t   d e v i c e   a d d r e s s   r e g i s t e r ,   p a g e d   w r i t e s ,   a n d   a c k n o w l e d g e   p o l l i n g . <br></td></tr
><tr
id=sl_svn22_26

><td class="source"> <br></td></tr
><tr
id=sl_svn22_27

><td class="source"> <br></td></tr
><tr
id=sl_svn22_28

><td class="source"> <br></td></tr
><tr
id=sl_svn22_29

><td class="source"> &#39; &#39;   A l l   o f   t h e s e   r e a d / w r i t e   r o u t i n e s   a c c e p t   a n   E E P R O M   a d d r e s s   u p   t o   1 9 <br></td></tr
><tr
id=sl_svn22_30

><td class="source"> <br></td></tr
><tr
id=sl_svn22_31

><td class="source"> &#39; &#39;   b i t s   ( 5 1 2 K )   e v e n   t h o u g h   t h e   E E P R O M   a d d r e s s i n g   s c h e m e   n o r m a l l y   a l l o w s <br></td></tr
><tr
id=sl_svn22_32

><td class="source"> <br></td></tr
><tr
id=sl_svn22_33

><td class="source"> &#39; &#39;   f o r   o n l y   1 6   b i t s   o f   a d d r e s s i n g .     T h e   u p p e r   3   b i t s   a r e   u s e d   a s   p a r t   o f <br></td></tr
><tr
id=sl_svn22_34

><td class="source"> <br></td></tr
><tr
id=sl_svn22_35

><td class="source"> &#39; &#39;   t h e   d e v i c e   s e l e c t   c o d e   a n d   t h e s e   r o u t i n e s   w i l l   t a k e   t h e   u p p e r   3   b i t s <br></td></tr
><tr
id=sl_svn22_36

><td class="source"> <br></td></tr
><tr
id=sl_svn22_37

><td class="source"> &#39; &#39;   o f   t h e   a d d r e s s   a n d   &quot; o r &quot;   i t   w i t h   t h e   s u p p l i e d   d e v i c e   s e l e c t   c o d e   b i t s <br></td></tr
><tr
id=sl_svn22_38

><td class="source"> <br></td></tr
><tr
id=sl_svn22_39

><td class="source"> &#39; &#39;   3 - 1   w h i c h   a r e   u s e d   t o   s e l e c t   a   p a r t i c u l a r   E E P R O M   o n   a n   I 2 C   b u s .     T h e r e <br></td></tr
><tr
id=sl_svn22_40

><td class="source"> <br></td></tr
><tr
id=sl_svn22_41

><td class="source"> &#39; &#39;   a r e   t w o   s c h e m e s   f o r   s e l e c t i n g   6 4 K   &quot; b a n k s &quot;   i n   1 2 8 K x 8   E E P R O M s .     A t m e l &#39; s <br></td></tr
><tr
id=sl_svn22_42

><td class="source"> <br></td></tr
><tr
id=sl_svn22_43

><td class="source"> &#39; &#39;   2 4 L C 1 0 2 4   E E P R O M s   a l l o w   s i m p l e   l i n e a r   a d d r e s s i n g   u p   t o   2 5 6 K x 8   ( $ 0 0 0 0 0 <br></td></tr
><tr
id=sl_svn22_44

><td class="source"> <br></td></tr
><tr
id=sl_svn22_45

><td class="source"> &#39; &#39;   t o   $ 3 F F F F ) .     M i c r o c h i p &#39; s   2 4 L C 1 0 2 5   a l l o w s   f o r   u p   t o   5 1 2 K x 8 ,   b u t   i n   t w o <br></td></tr
><tr
id=sl_svn22_46

><td class="source"> <br></td></tr
><tr
id=sl_svn22_47

><td class="source"> &#39; &#39;   a r e a s :   $ 0 0 0 0 0   t o   $ 3 F F F F   a n d   $ 4 0 0 0 0   t o   $ 7 F F F F .     E a c h   E E P R O M   p r o v i d e s <br></td></tr
><tr
id=sl_svn22_48

><td class="source"> <br></td></tr
><tr
id=sl_svn22_49

><td class="source"> &#39; &#39;   a   6 4 K   &quot; b a n k &quot;   i n   e a c h   a r e a .     S e e   t h e   d e v i c e   d a t a s h e e t s   f o r   d e t a i l s . <br></td></tr
><tr
id=sl_svn22_50

><td class="source"> <br></td></tr
><tr
id=sl_svn22_51

><td class="source"> <br></td></tr
><tr
id=sl_svn22_52

><td class="source"> <br></td></tr
><tr
id=sl_svn22_53

><td class="source"> &#39; &#39;   T h i s   w i l l   w o r k   w i t h   t h e   b o o t   E E P R O M   a n d   d o e s   n o t   r e q u i r e   a   p u l l - u p <br></td></tr
><tr
id=sl_svn22_54

><td class="source"> <br></td></tr
><tr
id=sl_svn22_55

><td class="source"> &#39; &#39;   r e s i s t o r   o n   t h e   S C L   l i n e   ( b u t   d o e s   o n   t h e   S D A   l i n e   . . .   a b o u t   4 . 7 K   t o <br></td></tr
><tr
id=sl_svn22_56

><td class="source"> <br></td></tr
><tr
id=sl_svn22_57

><td class="source"> &#39; &#39;   + 3 . 3 V ) .     A c c o r d i n g   t o   t h e   P h i l i p s   I 2 C   s p e c i f i c a t i o n ,   b o t h   p u l l - u p s <br></td></tr
><tr
id=sl_svn22_58

><td class="source"> <br></td></tr
><tr
id=sl_svn22_59

><td class="source"> &#39; &#39;   a r e   r e q u i r e d .     M a n y   d e v i c e s   w i l l   t o l e r a t e   t h e   a b s e n c e   o f   a   p u l l - u p <br></td></tr
><tr
id=sl_svn22_60

><td class="source"> <br></td></tr
><tr
id=sl_svn22_61

><td class="source"> &#39; &#39;   o n   S C L .     S o m e   m a y   t o l e r a t e   t h e   a b s e n c e   o f   a   p u l l - u p   o n   S D A   a s   w e l l . <br></td></tr
><tr
id=sl_svn22_62

><td class="source"> <br></td></tr
><tr
id=sl_svn22_63

><td class="source"> <br></td></tr
><tr
id=sl_svn22_64

><td class="source"> <br></td></tr
><tr
id=sl_svn22_65

><td class="source"> &#39; &#39;   I n i t i a l i z e   m a y   h a v e   t o   b e   c a l l e d   o n c e   a t   t h e   b e g i n n i n g   o f   y o u r <br></td></tr
><tr
id=sl_svn22_66

><td class="source"> <br></td></tr
><tr
id=sl_svn22_67

><td class="source"> &#39; &#39;   p r o g r a m .     S o m e t i m e s   a n   I 2 C   d e v i c e   i s   l e f t   i n   a n   i n v a l i d   s t a t e .     T h i s <br></td></tr
><tr
id=sl_svn22_68

><td class="source"> <br></td></tr
><tr
id=sl_svn22_69

><td class="source"> &#39; &#39;   w i l l   r e s e t   t h e   d e v i c e   t o   a   k n o w n   s t a t e   s o   i t   w i l l   r e s p o n d   t o   t h e   I 2 C <br></td></tr
><tr
id=sl_svn22_70

><td class="source"> <br></td></tr
><tr
id=sl_svn22_71

><td class="source"> &#39; &#39;   s t a r t   t r a n s i t i o n   ( s e n t   o u t   b y   t h e   i 2 c S t a r t   r o u t i n e ) . <br></td></tr
><tr
id=sl_svn22_72

><td class="source"> <br></td></tr
><tr
id=sl_svn22_73

><td class="source"> <br></td></tr
><tr
id=sl_svn22_74

><td class="source"> <br></td></tr
><tr
id=sl_svn22_75

><td class="source"> &#39; &#39;   T o   r e a d   f r o m   o r   w r i t e   t o   a n   E E P R O M   o n   p i n s   2 8 / 2 9   l i k e   t h e   b o o t   E E P R O M : <br></td></tr
><tr
id=sl_svn22_76

><td class="source"> <br></td></tr
><tr
id=sl_svn22_77

><td class="source"> <br></td></tr
><tr
id=sl_svn22_78

><td class="source"> <br></td></tr
><tr
id=sl_svn22_79

><td class="source"> &#39; &#39;   C O N <br></td></tr
><tr
id=sl_svn22_80

><td class="source"> <br></td></tr
><tr
id=sl_svn22_81

><td class="source"> &#39; &#39;       e e p r o m A d d r e s s   =   $ 7 0 0 0 <br></td></tr
><tr
id=sl_svn22_82

><td class="source"> <br></td></tr
><tr
id=sl_svn22_83

><td class="source"> <br></td></tr
><tr
id=sl_svn22_84

><td class="source"> <br></td></tr
><tr
id=sl_svn22_85

><td class="source"> &#39; &#39;   V A R <br></td></tr
><tr
id=sl_svn22_86

><td class="source"> <br></td></tr
><tr
id=sl_svn22_87

><td class="source"> &#39; &#39;       b y t e   b u f f e r [ 3 2 ] <br></td></tr
><tr
id=sl_svn22_88

><td class="source"> <br></td></tr
><tr
id=sl_svn22_89

><td class="source"> <br></td></tr
><tr
id=sl_svn22_90

><td class="source"> <br></td></tr
><tr
id=sl_svn22_91

><td class="source"> &#39; &#39;   O B J <br></td></tr
><tr
id=sl_svn22_92

><td class="source"> <br></td></tr
><tr
id=sl_svn22_93

><td class="source"> &#39; &#39;       i 2 c   :   &quot; M i n i m a l _ I 2 C _ D r i v e r &quot; <br></td></tr
><tr
id=sl_svn22_94

><td class="source"> <br></td></tr
><tr
id=sl_svn22_95

><td class="source"> <br></td></tr
><tr
id=sl_svn22_96

><td class="source"> <br></td></tr
><tr
id=sl_svn22_97

><td class="source"> &#39; &#39;   P R I   r e a d I t <br></td></tr
><tr
id=sl_svn22_98

><td class="source"> <br></td></tr
><tr
id=sl_svn22_99

><td class="source"> &#39; &#39;       i f   i 2 c . R e a d P a g e ( i 2 c # B o o t P i n ,   i 2 c # E E P R O M ,   e e p r o m A d d r e s s ,   @ b u f f e r ,   3 2 ) <br></td></tr
><tr
id=sl_svn22_100

><td class="source"> <br></td></tr
><tr
id=sl_svn22_101

><td class="source"> &#39; &#39;           a b o r t   &#39;   a n   e r r o r   o c c u r r e d   d u r i n g   t h e   r e a d <br></td></tr
><tr
id=sl_svn22_102

><td class="source"> <br></td></tr
><tr
id=sl_svn22_103

><td class="source"> <br></td></tr
><tr
id=sl_svn22_104

><td class="source"> <br></td></tr
><tr
id=sl_svn22_105

><td class="source"> &#39; &#39;   P R I   w r i t e I t   |   s t a r t T i m e <br></td></tr
><tr
id=sl_svn22_106

><td class="source"> <br></td></tr
><tr
id=sl_svn22_107

><td class="source"> &#39; &#39;       i f   i 2 c . W r i t e P a g e ( i 2 c # B o o t P i n ,   i 2 c # E E P R O M ,   e e p r o m A d d r e s s ,   @ b u f f e r ,   3 2 ) <br></td></tr
><tr
id=sl_svn22_108

><td class="source"> <br></td></tr
><tr
id=sl_svn22_109

><td class="source"> &#39; &#39;           a b o r t   &#39;   a n   e r r o r   o c c u r e d   d u r i n g   t h e   w r i t e <br></td></tr
><tr
id=sl_svn22_110

><td class="source"> <br></td></tr
><tr
id=sl_svn22_111

><td class="source"> &#39; &#39;       s t a r t T i m e   : =   c n t   &#39;   p r e p a r e   t o   c h e c k   f o r   a   t i m e o u t <br></td></tr
><tr
id=sl_svn22_112

><td class="source"> <br></td></tr
><tr
id=sl_svn22_113

><td class="source"> &#39; &#39;       r e p e a t   w h i l e   i 2 c . W r i t e W a i t ( i 2 c # B o o t P i n ,   i 2 c # E E P R O M ,   e e p r o m A d d r e s s ) <br></td></tr
><tr
id=sl_svn22_114

><td class="source"> <br></td></tr
><tr
id=sl_svn22_115

><td class="source"> &#39; &#39;           i f   c n t   -   s t a r t T i m e   &gt;   c l k f r e q   /   1 0 <br></td></tr
><tr
id=sl_svn22_116

><td class="source"> <br></td></tr
><tr
id=sl_svn22_117

><td class="source"> &#39; &#39;               a b o r t   &#39;   w a i t e d   m o r e   t h a n   a   1 / 1 0   s e c o n d   f o r   t h e   w r i t e   t o   f i n i s h <br></td></tr
><tr
id=sl_svn22_118

><td class="source"> <br></td></tr
><tr
id=sl_svn22_119

><td class="source"> <br></td></tr
><tr
id=sl_svn22_120

><td class="source"> <br></td></tr
><tr
id=sl_svn22_121

><td class="source"> &#39; &#39;   N o t e   t h a t   t h e   r e a d   a n d   w r i t e   u s e   s o m e t h i n g   c a l l e d   p a g e d   r e a d s / w r i t e s . <br></td></tr
><tr
id=sl_svn22_122

><td class="source"> <br></td></tr
><tr
id=sl_svn22_123

><td class="source"> &#39; &#39;   T h i s   m e a n s   t h a t   a n y   r e a d   u s i n g   R e a d P a g e   m u s t   f i t   e n t i r e l y   i n   o n e <br></td></tr
><tr
id=sl_svn22_124

><td class="source"> <br></td></tr
><tr
id=sl_svn22_125

><td class="source"> &#39; &#39;   E E P R O M   i f   y o u   h a v e   s e v e r a l   a t t a c h e d   t o   o n e   s e t   o f   p i n s .     F o r   w r i t e s , <br></td></tr
><tr
id=sl_svn22_126

><td class="source"> <br></td></tr
><tr
id=sl_svn22_127

><td class="source"> &#39; &#39;   a n y   w r i t e   u s i n g   i 2 c W r i t e P a g e   m u s t   f i t   e n t i r e l y   w i t h i n   a   p a g e   o f   t h e <br></td></tr
><tr
id=sl_svn22_128

><td class="source"> <br></td></tr
><tr
id=sl_svn22_129

><td class="source"> &#39; &#39;   E E P R O M .     U s u a l l y   t h e s e   p a g e s   a r e   e i t h e r   3 2 ,   6 4 ,   1 2 8   o r   2 5 6   b y t e s   i n <br></td></tr
><tr
id=sl_svn22_130

><td class="source"> <br></td></tr
><tr
id=sl_svn22_131

><td class="source"> &#39; &#39;   s i z e   d e p e n d i n g   o n   t h e   m a n u f a c t u r e r   a n d   d e v i c e   t y p e .     3 2   b y t e s   i s   a <br></td></tr
><tr
id=sl_svn22_132

><td class="source"> <br></td></tr
><tr
id=sl_svn22_133

><td class="source"> &#39; &#39;   g o o d   l i m i t   f o r   t h e   n u m b e r   o f   b y t e s   t o   b e   w r i t t e n   a t   a   t i m e   i f   y o u <br></td></tr
><tr
id=sl_svn22_134

><td class="source"> <br></td></tr
><tr
id=sl_svn22_135

><td class="source"> &#39; &#39;   d o n &#39; t   k n o w   t h e   s p e c i f i c   p a g e   s i z e   ( a n d   t h e   w r i t e   m u s t   f i t   c o m p l e t e l y <br></td></tr
><tr
id=sl_svn22_136

><td class="source"> <br></td></tr
><tr
id=sl_svn22_137

><td class="source"> &#39; &#39;   w i t h i n   a   m u l t i p l e   o f   t h e   p a g e   s i z e ) .     T h e   W r i t e W a i t   w a i t s   f o r   t h e <br></td></tr
><tr
id=sl_svn22_138

><td class="source"> <br></td></tr
><tr
id=sl_svn22_139

><td class="source"> &#39; &#39;   w r i t e   o p e r a t i o n   t o   c o m p l e t e .     A l t e r n a t i v e l y ,   y o u   c o u l d   w a i t   f o r   5 m s <br></td></tr
><tr
id=sl_svn22_140

><td class="source"> <br></td></tr
><tr
id=sl_svn22_141

><td class="source"> &#39; &#39;   s i n c e   c u r r e n t l y   p r o d u c e d   E E P R O M s   w i l l   f i n i s h   w i t h i n   t h a t   t i m e . <br></td></tr
><tr
id=sl_svn22_142

><td class="source"> <br></td></tr
><tr
id=sl_svn22_143

><td class="source"> <br></td></tr
><tr
id=sl_svn22_144

><td class="source"> <br></td></tr
><tr
id=sl_svn22_145

><td class="source"> C O N <br></td></tr
><tr
id=sl_svn22_146

><td class="source"> <br></td></tr
><tr
id=sl_svn22_147

><td class="source">       A C K             =   0                                                 &#39;   I 2 C   A c k n o w l e d g e <br></td></tr
><tr
id=sl_svn22_148

><td class="source"> <br></td></tr
><tr
id=sl_svn22_149

><td class="source">       N A K             =   1                                                 &#39;   I 2 C   N o   A c k n o w l e d g e <br></td></tr
><tr
id=sl_svn22_150

><td class="source"> <br></td></tr
><tr
id=sl_svn22_151

><td class="source">       X m i t           =   0                                                 &#39;   I 2 C   D i r e c t i o n   T r a n s m i t <br></td></tr
><tr
id=sl_svn22_152

><td class="source"> <br></td></tr
><tr
id=sl_svn22_153

><td class="source">       R e c v           =   1                                                 &#39;   I 2 C   D i r e c t i o n   R e c e i v e <br></td></tr
><tr
id=sl_svn22_154

><td class="source"> <br></td></tr
><tr
id=sl_svn22_155

><td class="source">       B o o t P i n     =   2 8                                               &#39;   I 2 C   B o o t   E E P R O M   S C L   P i n <br></td></tr
><tr
id=sl_svn22_156

><td class="source"> <br></td></tr
><tr
id=sl_svn22_157

><td class="source">       E E P R O M       =   $ A 0                                             &#39;   I 2 C   E E P R O M   D e v i c e   A d d r e s s <br></td></tr
><tr
id=sl_svn22_158

><td class="source"> <br></td></tr
><tr
id=sl_svn22_159

><td class="source"> <br></td></tr
><tr
id=sl_svn22_160

><td class="source"> <br></td></tr
><tr
id=sl_svn22_161

><td class="source"> P U B   I n i t i a l i z e ( S C L )   |   S D A                             &#39;   A n   I 2 C   d e v i c e   m a y   b e   l e f t   i n   a n <br></td></tr
><tr
id=sl_svn22_162

><td class="source"> <br></td></tr
><tr
id=sl_svn22_163

><td class="source">       S D A   : =   S C L   +   1                                             &#39;     i n v a l i d   s t a t e   a n d   m a y   n e e d   t o   b e <br></td></tr
><tr
id=sl_svn22_164

><td class="source"> <br></td></tr
><tr
id=sl_svn22_165

><td class="source">       o u t a [ S C L ]   : =   1                                               &#39;       r e i n i t i a l i z e d .     D r i v e   S C L   h i g h . <br></td></tr
><tr
id=sl_svn22_166

><td class="source"> <br></td></tr
><tr
id=sl_svn22_167

><td class="source">       d i r a [ S C L ]   : =   1 <br></td></tr
><tr
id=sl_svn22_168

><td class="source"> <br></td></tr
><tr
id=sl_svn22_169

><td class="source">       d i r a [ S D A ]   : =   0                                               &#39;   S e t   S D A   a s   i n p u t <br></td></tr
><tr
id=sl_svn22_170

><td class="source"> <br></td></tr
><tr
id=sl_svn22_171

><td class="source">       r e p e a t   9 <br></td></tr
><tr
id=sl_svn22_172

><td class="source"> <br></td></tr
><tr
id=sl_svn22_173

><td class="source">             o u t a [ S C L ]   : =   0                                         &#39;   P u t   o u t   u p   t o   9   c l o c k   p u l s e s <br></td></tr
><tr
id=sl_svn22_174

><td class="source"> <br></td></tr
><tr
id=sl_svn22_175

><td class="source">             o u t a [ S C L ]   : =   1 <br></td></tr
><tr
id=sl_svn22_176

><td class="source"> <br></td></tr
><tr
id=sl_svn22_177

><td class="source">             i f   i n a [ S D A ]                                             &#39;   R e p e a t   i f   S D A   n o t   d r i v e n   h i g h <br></td></tr
><tr
id=sl_svn22_178

><td class="source"> <br></td></tr
><tr
id=sl_svn22_179

><td class="source">                   q u i t                                                     &#39;     b y   t h e   E E P R O M <br></td></tr
><tr
id=sl_svn22_180

><td class="source"> <br></td></tr
><tr
id=sl_svn22_181

><td class="source"> <br></td></tr
><tr
id=sl_svn22_182

><td class="source"> <br></td></tr
><tr
id=sl_svn22_183

><td class="source"> P U B   S t a r t ( S C L )   |   S D A                                       &#39;   S D A   g o e s   H I G H   t o   L O W   w i t h   S C L   H I G H <br></td></tr
><tr
id=sl_svn22_184

><td class="source"> <br></td></tr
><tr
id=sl_svn22_185

><td class="source">       S D A   : =   S C L   +   1 <br></td></tr
><tr
id=sl_svn22_186

><td class="source"> <br></td></tr
><tr
id=sl_svn22_187

><td class="source">       o u t a [ S C L ] ~ ~                                                   &#39;   I n i t i a l l y   d r i v e   S C L   H I G H <br></td></tr
><tr
id=sl_svn22_188

><td class="source"> <br></td></tr
><tr
id=sl_svn22_189

><td class="source">       d i r a [ S C L ] ~ ~ <br></td></tr
><tr
id=sl_svn22_190

><td class="source"> <br></td></tr
><tr
id=sl_svn22_191

><td class="source">       o u t a [ S D A ] ~ ~                                                   &#39;   I n i t i a l l y   d r i v e   S D A   H I G H <br></td></tr
><tr
id=sl_svn22_192

><td class="source"> <br></td></tr
><tr
id=sl_svn22_193

><td class="source">       d i r a [ S D A ] ~ ~ <br></td></tr
><tr
id=sl_svn22_194

><td class="source"> <br></td></tr
><tr
id=sl_svn22_195

><td class="source">       o u t a [ S D A ] ~                                                     &#39;   N o w   d r i v e   S D A   L O W <br></td></tr
><tr
id=sl_svn22_196

><td class="source"> <br></td></tr
><tr
id=sl_svn22_197

><td class="source">       o u t a [ S C L ] ~                                                     &#39;   L e a v e   S C L   L O W <br></td></tr
><tr
id=sl_svn22_198

><td class="source"> <br></td></tr
><tr
id=sl_svn22_199

><td class="source">     <br></td></tr
><tr
id=sl_svn22_200

><td class="source"> <br></td></tr
><tr
id=sl_svn22_201

><td class="source"> P U B   S t o p ( S C L )   |   S D A                                         &#39;   S D A   g o e s   L O W   t o   H I G H   w i t h   S C L   H i g h <br></td></tr
><tr
id=sl_svn22_202

><td class="source"> <br></td></tr
><tr
id=sl_svn22_203

><td class="source">       S D A   : =   S C L   +   1 <br></td></tr
><tr
id=sl_svn22_204

><td class="source"> <br></td></tr
><tr
id=sl_svn22_205

><td class="source">       o u t a [ S C L ] ~ ~                                                   &#39;   D r i v e   S C L   H I G H <br></td></tr
><tr
id=sl_svn22_206

><td class="source"> <br></td></tr
><tr
id=sl_svn22_207

><td class="source">       o u t a [ S D A ] ~ ~                                                   &#39;     t h e n   S D A   H I G H <br></td></tr
><tr
id=sl_svn22_208

><td class="source"> <br></td></tr
><tr
id=sl_svn22_209

><td class="source">       d i r a [ S C L ] ~                                                     &#39;   N o w   l e t   t h e m   f l o a t <br></td></tr
><tr
id=sl_svn22_210

><td class="source"> <br></td></tr
><tr
id=sl_svn22_211

><td class="source">       d i r a [ S D A ] ~                                                     &#39;   I f   p u l l u p s   p r e s e n t ,   t h e y &#39; l l   s t a y   H I G H <br></td></tr
><tr
id=sl_svn22_212

><td class="source"> <br></td></tr
><tr
id=sl_svn22_213

><td class="source"> <br></td></tr
><tr
id=sl_svn22_214

><td class="source"> <br></td></tr
><tr
id=sl_svn22_215

><td class="source"> P U B   W r i t e ( S C L ,   d a t a )   :   a c k b i t   |   S D A <br></td></tr
><tr
id=sl_svn22_216

><td class="source"> <br></td></tr
><tr
id=sl_svn22_217

><td class="source"> &#39; &#39;   W r i t e   i 2 c   d a t a .     D a t a   b y t e   i s   o u t p u t   M S B   f i r s t ,   S D A   d a t a   l i n e   i s   v a l i d <br></td></tr
><tr
id=sl_svn22_218

><td class="source"> <br></td></tr
><tr
id=sl_svn22_219

><td class="source"> &#39; &#39;   o n l y   w h i l e   t h e   S C L   l i n e   i s   H I G H .     D a t a   i s   a l w a y s   8   b i t s   ( +   A C K / N A K ) . <br></td></tr
><tr
id=sl_svn22_220

><td class="source"> <br></td></tr
><tr
id=sl_svn22_221

><td class="source"> &#39; &#39;   S D A   i s   a s s u m e d   L O W   a n d   S C L   a n d   S D A   a r e   b o t h   l e f t   i n   t h e   L O W   s t a t e . <br></td></tr
><tr
id=sl_svn22_222

><td class="source"> <br></td></tr
><tr
id=sl_svn22_223

><td class="source">       S D A   : =   S C L   +   1 <br></td></tr
><tr
id=sl_svn22_224

><td class="source"> <br></td></tr
><tr
id=sl_svn22_225

><td class="source">       a c k b i t   : =   0   <br></td></tr
><tr
id=sl_svn22_226

><td class="source"> <br></td></tr
><tr
id=sl_svn22_227

><td class="source">       d a t a   &lt; &lt; =   2 4 <br></td></tr
><tr
id=sl_svn22_228

><td class="source"> <br></td></tr
><tr
id=sl_svn22_229

><td class="source">       r e p e a t   8                                                         &#39;   O u t p u t   d a t a   t o   S D A <br></td></tr
><tr
id=sl_svn22_230

><td class="source"> <br></td></tr
><tr
id=sl_svn22_231

><td class="source">             o u t a [ S D A ]   : =   ( d a t a   &lt; - =   1 )   &amp;   1 <br></td></tr
><tr
id=sl_svn22_232

><td class="source"> <br></td></tr
><tr
id=sl_svn22_233

><td class="source">             o u t a [ S C L ] ~ ~                                             &#39;   T o g g l e   S C L   f r o m   L O W   t o   H I G H   t o   L O W <br></td></tr
><tr
id=sl_svn22_234

><td class="source"> <br></td></tr
><tr
id=sl_svn22_235

><td class="source">             o u t a [ S C L ] ~ <br></td></tr
><tr
id=sl_svn22_236

><td class="source"> <br></td></tr
><tr
id=sl_svn22_237

><td class="source">       d i r a [ S D A ] ~                                                     &#39;   S e t   S D A   t o   i n p u t   f o r   A C K / N A K <br></td></tr
><tr
id=sl_svn22_238

><td class="source"> <br></td></tr
><tr
id=sl_svn22_239

><td class="source">       o u t a [ S C L ] ~ ~ <br></td></tr
><tr
id=sl_svn22_240

><td class="source"> <br></td></tr
><tr
id=sl_svn22_241

><td class="source">       a c k b i t   : =   i n a [ S D A ]                                     &#39;   S a m p l e   S D A   w h e n   S C L   i s   H I G H <br></td></tr
><tr
id=sl_svn22_242

><td class="source"> <br></td></tr
><tr
id=sl_svn22_243

><td class="source">       o u t a [ S C L ] ~ <br></td></tr
><tr
id=sl_svn22_244

><td class="source"> <br></td></tr
><tr
id=sl_svn22_245

><td class="source">       o u t a [ S D A ] ~                                                     &#39;   L e a v e   S D A   d r i v e n   L O W <br></td></tr
><tr
id=sl_svn22_246

><td class="source"> <br></td></tr
><tr
id=sl_svn22_247

><td class="source">       d i r a [ S D A ] ~ ~ <br></td></tr
><tr
id=sl_svn22_248

><td class="source"> <br></td></tr
><tr
id=sl_svn22_249

><td class="source"> <br></td></tr
><tr
id=sl_svn22_250

><td class="source"> <br></td></tr
><tr
id=sl_svn22_251

><td class="source"> P U B   R e a d ( S C L ,   a c k b i t ) :   d a t a   |   S D A <br></td></tr
><tr
id=sl_svn22_252

><td class="source"> <br></td></tr
><tr
id=sl_svn22_253

><td class="source"> &#39; &#39;   R e a d   i n   i 2 c   d a t a ,   D a t a   b y t e   i s   o u t p u t   M S B   f i r s t ,   S D A   d a t a   l i n e   i s <br></td></tr
><tr
id=sl_svn22_254

><td class="source"> <br></td></tr
><tr
id=sl_svn22_255

><td class="source"> &#39; &#39;   v a l i d   o n l y   w h i l e   t h e   S C L   l i n e   i s   H I G H .     S C L   a n d   S D A   l e f t   i n   L O W   s t a t e . <br></td></tr
><tr
id=sl_svn22_256

><td class="source"> <br></td></tr
><tr
id=sl_svn22_257

><td class="source">       S D A   : =   S C L   +   1 <br></td></tr
><tr
id=sl_svn22_258

><td class="source"> <br></td></tr
><tr
id=sl_svn22_259

><td class="source">       d a t a   : =   0 <br></td></tr
><tr
id=sl_svn22_260

><td class="source"> <br></td></tr
><tr
id=sl_svn22_261

><td class="source">       d i r a [ S D A ] ~                                                     &#39;   M a k e   S D A   a n   i n p u t <br></td></tr
><tr
id=sl_svn22_262

><td class="source"> <br></td></tr
><tr
id=sl_svn22_263

><td class="source">       r e p e a t   8                                                         &#39;   R e c e i v e   d a t a   f r o m   S D A <br></td></tr
><tr
id=sl_svn22_264

><td class="source"> <br></td></tr
><tr
id=sl_svn22_265

><td class="source">             o u t a [ S C L ] ~ ~                                             &#39;   S a m p l e   S D A   w h e n   S C L   i s   H I G H <br></td></tr
><tr
id=sl_svn22_266

><td class="source"> <br></td></tr
><tr
id=sl_svn22_267

><td class="source">             d a t a   : =   ( d a t a   &lt; &lt;   1 )   |   i n a [ S D A ] <br></td></tr
><tr
id=sl_svn22_268

><td class="source"> <br></td></tr
><tr
id=sl_svn22_269

><td class="source">             o u t a [ S C L ] ~ <br></td></tr
><tr
id=sl_svn22_270

><td class="source"> <br></td></tr
><tr
id=sl_svn22_271

><td class="source">       o u t a [ S D A ]   : =   a c k b i t                                   &#39;   O u t p u t   A C K / N A K   t o   S D A <br></td></tr
><tr
id=sl_svn22_272

><td class="source"> <br></td></tr
><tr
id=sl_svn22_273

><td class="source">       d i r a [ S D A ] ~ ~ <br></td></tr
><tr
id=sl_svn22_274

><td class="source"> <br></td></tr
><tr
id=sl_svn22_275

><td class="source">       o u t a [ S C L ] ~ ~                                                   &#39;   T o g g l e   S C L   f r o m   L O W   t o   H I G H   t o   L O W <br></td></tr
><tr
id=sl_svn22_276

><td class="source"> <br></td></tr
><tr
id=sl_svn22_277

><td class="source">       o u t a [ S C L ] ~ <br></td></tr
><tr
id=sl_svn22_278

><td class="source"> <br></td></tr
><tr
id=sl_svn22_279

><td class="source">       o u t a [ S D A ] ~                                                     &#39;   L e a v e   S D A   d r i v e n   L O W <br></td></tr
><tr
id=sl_svn22_280

><td class="source"> <br></td></tr
><tr
id=sl_svn22_281

><td class="source"> <br></td></tr
><tr
id=sl_svn22_282

><td class="source"> <br></td></tr
><tr
id=sl_svn22_283

><td class="source"> P U B   R e a d P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   d a t a P t r ,   c o u n t )   :   a c k b i t <br></td></tr
><tr
id=sl_svn22_284

><td class="source"> <br></td></tr
><tr
id=sl_svn22_285

><td class="source"> &#39; &#39;   R e a d   i n   a   b l o c k   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e   s t a r t i n g <br></td></tr
><tr
id=sl_svn22_286

><td class="source"> <br></td></tr
><tr
id=sl_svn22_287

><td class="source"> &#39; &#39;   a d d r e s s   i s   a d d r R e g .     D a t a   a d d r e s s   i s   a t   d a t a P t r .     N u m b e r   o f   b y t e s   i s   c o u n t . <br></td></tr
><tr
id=sl_svn22_288

><td class="source"> <br></td></tr
><tr
id=sl_svn22_289

><td class="source"> &#39; &#39;   T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g . <br></td></tr
><tr
id=sl_svn22_290

><td class="source"> <br></td></tr
><tr
id=sl_svn22_291

><td class="source"> &#39; &#39;   R e t u r n   z e r o   i f   n o   e r r o r s   o r   t h e   a c k n o w l e d g e   b i t s   i f   a n   e r r o r   o c c u r r e d . <br></td></tr
><tr
id=sl_svn22_292

><td class="source"> <br></td></tr
><tr
id=sl_svn22_293

><td class="source">       d e v S e l   | =   a d d r R e g   &gt; &gt;   1 5   &amp;   % 1 1 1 0 <br></td></tr
><tr
id=sl_svn22_294

><td class="source"> <br></td></tr
><tr
id=sl_svn22_295

><td class="source">       S t a r t ( S C L )                                                     &#39;   S e l e c t   t h e   d e v i c e   &amp;   s e n d   a d d r e s s <br></td></tr
><tr
id=sl_svn22_296

><td class="source"> <br></td></tr
><tr
id=sl_svn22_297

><td class="source">       a c k b i t   : =   W r i t e ( S C L ,   d e v S e l   |   X m i t ) <br></td></tr
><tr
id=sl_svn22_298

><td class="source"> <br></td></tr
><tr
id=sl_svn22_299

><td class="source">       a c k b i t   : =   ( a c k b i t   &lt; &lt;   1 )   |   W r i t e ( S C L ,   a d d r R e g   &gt; &gt;   8   &amp;   $ F F ) <br></td></tr
><tr
id=sl_svn22_300

><td class="source"> <br></td></tr
><tr
id=sl_svn22_301

><td class="source">       a c k b i t   : =   ( a c k b i t   &lt; &lt;   1 )   |   W r i t e ( S C L ,   a d d r R e g   &amp;   $ F F )                     <br></td></tr
><tr
id=sl_svn22_302

><td class="source"> <br></td></tr
><tr
id=sl_svn22_303

><td class="source">       S t a r t ( S C L )                                                     &#39;   R e s e l e c t   t h e   d e v i c e   f o r   r e a d i n g <br></td></tr
><tr
id=sl_svn22_304

><td class="source"> <br></td></tr
><tr
id=sl_svn22_305

><td class="source">       a c k b i t   : =   ( a c k b i t   &lt; &lt;   1 )   |   W r i t e ( S C L ,   d e v S e l   |   R e c v ) <br></td></tr
><tr
id=sl_svn22_306

><td class="source"> <br></td></tr
><tr
id=sl_svn22_307

><td class="source">       r e p e a t   c o u n t   -   1 <br></td></tr
><tr
id=sl_svn22_308

><td class="source"> <br></td></tr
><tr
id=sl_svn22_309

><td class="source">             b y t e [ d a t a P t r + + ]   : =   R e a d ( S C L ,   A C K ) <br></td></tr
><tr
id=sl_svn22_310

><td class="source"> <br></td></tr
><tr
id=sl_svn22_311

><td class="source">       b y t e [ d a t a P t r + + ]   : =   R e a d ( S C L ,   N A K ) <br></td></tr
><tr
id=sl_svn22_312

><td class="source"> <br></td></tr
><tr
id=sl_svn22_313

><td class="source">       S t o p ( S C L ) <br></td></tr
><tr
id=sl_svn22_314

><td class="source"> <br></td></tr
><tr
id=sl_svn22_315

><td class="source">       r e t u r n   a c k b i t <br></td></tr
><tr
id=sl_svn22_316

><td class="source"> <br></td></tr
><tr
id=sl_svn22_317

><td class="source"> <br></td></tr
><tr
id=sl_svn22_318

><td class="source"> <br></td></tr
><tr
id=sl_svn22_319

><td class="source"> P U B   R e a d B y t e ( S C L ,   d e v S e l ,   a d d r R e g )   :   d a t a <br></td></tr
><tr
id=sl_svn22_320

><td class="source"> <br></td></tr
><tr
id=sl_svn22_321

><td class="source"> &#39; &#39;   R e a d   i n   a   s i n g l e   b y t e   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e <br></td></tr
><tr
id=sl_svn22_322

><td class="source"> <br></td></tr
><tr
id=sl_svn22_323

><td class="source"> &#39; &#39;   s t a r t i n g   a d d r e s s   i s   a d d r R e g .     T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e <br></td></tr
><tr
id=sl_svn22_324

><td class="source"> <br></td></tr
><tr
id=sl_svn22_325

><td class="source"> &#39; &#39;   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g .     T h i s   r e t u r n s   t r u e   i f   a n   e r r o r   o c c u r r e d . <br></td></tr
><tr
id=sl_svn22_326

><td class="source"> <br></td></tr
><tr
id=sl_svn22_327

><td class="source">       i f   R e a d P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   @ d a t a ,   1 ) <br></td></tr
><tr
id=sl_svn22_328

><td class="source"> <br></td></tr
><tr
id=sl_svn22_329

><td class="source">             r e t u r n   - 1 <br></td></tr
><tr
id=sl_svn22_330

><td class="source"> <br></td></tr
><tr
id=sl_svn22_331

><td class="source"> <br></td></tr
><tr
id=sl_svn22_332

><td class="source"> <br></td></tr
><tr
id=sl_svn22_333

><td class="source"> P U B   R e a d W o r d ( S C L ,   d e v S e l ,   a d d r R e g )   :   d a t a <br></td></tr
><tr
id=sl_svn22_334

><td class="source"> <br></td></tr
><tr
id=sl_svn22_335

><td class="source"> &#39; &#39;   R e a d   i n   a   s i n g l e   w o r d   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e <br></td></tr
><tr
id=sl_svn22_336

><td class="source"> <br></td></tr
><tr
id=sl_svn22_337

><td class="source"> &#39; &#39;   s t a r t i n g   a d d r e s s   i s   a d d r R e g .     T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e <br></td></tr
><tr
id=sl_svn22_338

><td class="source"> <br></td></tr
><tr
id=sl_svn22_339

><td class="source"> &#39; &#39;   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g .     T h i s   r e t u r n s   t r u e   i f   a n   e r r o r   o c c u r r e d . <br></td></tr
><tr
id=sl_svn22_340

><td class="source"> <br></td></tr
><tr
id=sl_svn22_341

><td class="source">       i f   R e a d P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   @ d a t a ,   2 ) <br></td></tr
><tr
id=sl_svn22_342

><td class="source"> <br></td></tr
><tr
id=sl_svn22_343

><td class="source">             r e t u r n   - 1 <br></td></tr
><tr
id=sl_svn22_344

><td class="source"> <br></td></tr
><tr
id=sl_svn22_345

><td class="source"> <br></td></tr
><tr
id=sl_svn22_346

><td class="source"> <br></td></tr
><tr
id=sl_svn22_347

><td class="source"> P U B   R e a d L o n g ( S C L ,   d e v S e l ,   a d d r R e g )   :   d a t a <br></td></tr
><tr
id=sl_svn22_348

><td class="source"> <br></td></tr
><tr
id=sl_svn22_349

><td class="source"> &#39; &#39;   R e a d   i n   a   s i n g l e   l o n g   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e <br></td></tr
><tr
id=sl_svn22_350

><td class="source"> <br></td></tr
><tr
id=sl_svn22_351

><td class="source"> &#39; &#39;   s t a r t i n g   a d d r e s s   i s   a d d r R e g .     T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e <br></td></tr
><tr
id=sl_svn22_352

><td class="source"> <br></td></tr
><tr
id=sl_svn22_353

><td class="source"> &#39; &#39;   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g .     T h i s   r e t u r n s   t r u e   i f   a n   e r r o r   o c c u r r e d . <br></td></tr
><tr
id=sl_svn22_354

><td class="source"> <br></td></tr
><tr
id=sl_svn22_355

><td class="source"> &#39; &#39;   N o t e   t h a t   y o u   c a n &#39; t   d i s t i n g u i s h   b e t w e e n   a   r e t u r n   v a l u e   o f   - 1   a n d   t r u e   e r r o r . <br></td></tr
><tr
id=sl_svn22_356

><td class="source"> <br></td></tr
><tr
id=sl_svn22_357

><td class="source">       i f   R e a d P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   @ d a t a ,   4 ) <br></td></tr
><tr
id=sl_svn22_358

><td class="source"> <br></td></tr
><tr
id=sl_svn22_359

><td class="source">             r e t u r n   - 1 <br></td></tr
><tr
id=sl_svn22_360

><td class="source"> <br></td></tr
><tr
id=sl_svn22_361

><td class="source"> <br></td></tr
><tr
id=sl_svn22_362

><td class="source"> <br></td></tr
><tr
id=sl_svn22_363

><td class="source"> P U B   W r i t e P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   d a t a P t r ,   c o u n t )   :   a c k b i t <br></td></tr
><tr
id=sl_svn22_364

><td class="source"> <br></td></tr
><tr
id=sl_svn22_365

><td class="source"> &#39; &#39;   W r i t e   o u t   a   b l o c k   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e   s t a r t i n g <br></td></tr
><tr
id=sl_svn22_366

><td class="source"> <br></td></tr
><tr
id=sl_svn22_367

><td class="source"> &#39; &#39;   a d d r e s s   i s   a d d r R e g .     D a t a   a d d r e s s   i s   a t   d a t a P t r .     N u m b e r   o f   b y t e s   i s   c o u n t . <br></td></tr
><tr
id=sl_svn22_368

><td class="source"> <br></td></tr
><tr
id=sl_svn22_369

><td class="source"> &#39; &#39;   T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g . <br></td></tr
><tr
id=sl_svn22_370

><td class="source"> <br></td></tr
><tr
id=sl_svn22_371

><td class="source"> &#39; &#39;   M o s t   d e v i c e s   h a v e   a   p a g e   s i z e   o f   a t   l e a s t   3 2   b y t e s ,   s o m e   a s   l a r g e   a s   2 5 6   b y t e s . <br></td></tr
><tr
id=sl_svn22_372

><td class="source"> <br></td></tr
><tr
id=sl_svn22_373

><td class="source"> &#39; &#39;   R e t u r n   z e r o   i f   n o   e r r o r s   o r   t h e   a c k n o w l e d g e   b i t s   i f   a n   e r r o r   o c c u r r e d .     I f <br></td></tr
><tr
id=sl_svn22_374

><td class="source"> <br></td></tr
><tr
id=sl_svn22_375

><td class="source"> &#39; &#39;   m o r e   t h a n   3 1   b y t e s   a r e   t r a n s m i t t e d ,   t h e   s i g n   b i t   i s   &quot; s t i c k y &quot;   a n d   i s   t h e <br></td></tr
><tr
id=sl_svn22_376

><td class="source"> <br></td></tr
><tr
id=sl_svn22_377

><td class="source"> &#39; &#39;   l o g i c a l   &quot; o r &quot;   o f   t h e   a c k n o w l e d g e   b i t s   o f   a n y   b y t e s   p a s t   t h e   3 1 s t . <br></td></tr
><tr
id=sl_svn22_378

><td class="source"> <br></td></tr
><tr
id=sl_svn22_379

><td class="source">       d e v S e l   | =   a d d r R e g   &gt; &gt;   1 5   &amp;   % 1 1 1 0 <br></td></tr
><tr
id=sl_svn22_380

><td class="source"> <br></td></tr
><tr
id=sl_svn22_381

><td class="source">       S t a r t ( S C L )                                                     &#39;   S e l e c t   t h e   d e v i c e   &amp;   s e n d   a d d r e s s <br></td></tr
><tr
id=sl_svn22_382

><td class="source"> <br></td></tr
><tr
id=sl_svn22_383

><td class="source">       a c k b i t   : =   W r i t e ( S C L ,   d e v S e l   |   X m i t ) <br></td></tr
><tr
id=sl_svn22_384

><td class="source"> <br></td></tr
><tr
id=sl_svn22_385

><td class="source">       a c k b i t   : =   ( a c k b i t   &lt; &lt;   1 )   |   W r i t e ( S C L ,   a d d r R e g   &gt; &gt;   8   &amp;   $ F F ) <br></td></tr
><tr
id=sl_svn22_386

><td class="source"> <br></td></tr
><tr
id=sl_svn22_387

><td class="source">       a c k b i t   : =   ( a c k b i t   &lt; &lt;   1 )   |   W r i t e ( S C L ,   a d d r R e g   &amp;   $ F F )                     <br></td></tr
><tr
id=sl_svn22_388

><td class="source"> <br></td></tr
><tr
id=sl_svn22_389

><td class="source">       r e p e a t   c o u n t                                                 &#39;   N o w   s e n d   t h e   d a t a <br></td></tr
><tr
id=sl_svn22_390

><td class="source"> <br></td></tr
><tr
id=sl_svn22_391

><td class="source">             a c k b i t   : =   a c k b i t   &lt; &lt;   1   |   a c k b i t   &amp;   $ 8 0 0 0 0 0 0 0   &#39;   &quot; S t i c k y &quot;   s i g n   b i t                   <br></td></tr
><tr
id=sl_svn22_392

><td class="source"> <br></td></tr
><tr
id=sl_svn22_393

><td class="source">             a c k b i t   | =   W r i t e ( S C L ,   b y t e [ d a t a P t r + + ] ) <br></td></tr
><tr
id=sl_svn22_394

><td class="source"> <br></td></tr
><tr
id=sl_svn22_395

><td class="source">       S t o p ( S C L ) <br></td></tr
><tr
id=sl_svn22_396

><td class="source"> <br></td></tr
><tr
id=sl_svn22_397

><td class="source">       r e t u r n   a c k b i t <br></td></tr
><tr
id=sl_svn22_398

><td class="source"> <br></td></tr
><tr
id=sl_svn22_399

><td class="source"> <br></td></tr
><tr
id=sl_svn22_400

><td class="source"> <br></td></tr
><tr
id=sl_svn22_401

><td class="source"> P U B   W r i t e B y t e ( S C L ,   d e v S e l ,   a d d r R e g ,   d a t a ) <br></td></tr
><tr
id=sl_svn22_402

><td class="source"> <br></td></tr
><tr
id=sl_svn22_403

><td class="source"> &#39; &#39;   W r i t e   o u t   a   s i n g l e   b y t e   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e <br></td></tr
><tr
id=sl_svn22_404

><td class="source"> <br></td></tr
><tr
id=sl_svn22_405

><td class="source"> &#39; &#39;   s t a r t i n g   a d d r e s s   i s   a d d r R e g .     T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e <br></td></tr
><tr
id=sl_svn22_406

><td class="source"> <br></td></tr
><tr
id=sl_svn22_407

><td class="source"> &#39; &#39;   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g .     T h i s   r e t u r n s   t r u e   i f   a n   e r r o r   o c c u r r e d . <br></td></tr
><tr
id=sl_svn22_408

><td class="source"> <br></td></tr
><tr
id=sl_svn22_409

><td class="source">       i f   W r i t e P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   @ d a t a ,   1 ) <br></td></tr
><tr
id=sl_svn22_410

><td class="source"> <br></td></tr
><tr
id=sl_svn22_411

><td class="source">             r e t u r n   t r u e <br></td></tr
><tr
id=sl_svn22_412

><td class="source"> <br></td></tr
><tr
id=sl_svn22_413

><td class="source">       &#39;   j a m e s   e d i t   -   w a i t   f o r   5 m s   f o r   p a g e   w r i t e   t o   c o m p l e t e   ( 8 0 _ 0 0 0   *   5   =   4 0 0 _ 0 0 0 )             <br></td></tr
><tr
id=sl_svn22_414

><td class="source"> <br></td></tr
><tr
id=sl_svn22_415

><td class="source">       w a i t c n t ( 4 0 0 _ 0 0 0   +   c n t )             <br></td></tr
><tr
id=sl_svn22_416

><td class="source"> <br></td></tr
><tr
id=sl_svn22_417

><td class="source">       r e t u r n   f a l s e <br></td></tr
><tr
id=sl_svn22_418

><td class="source"> <br></td></tr
><tr
id=sl_svn22_419

><td class="source"> <br></td></tr
><tr
id=sl_svn22_420

><td class="source"> <br></td></tr
><tr
id=sl_svn22_421

><td class="source"> P U B   W r i t e W o r d ( S C L ,   d e v S e l ,   a d d r R e g ,   d a t a ) <br></td></tr
><tr
id=sl_svn22_422

><td class="source"> <br></td></tr
><tr
id=sl_svn22_423

><td class="source"> &#39; &#39;   W r i t e   o u t   a   s i n g l e   w o r d   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e <br></td></tr
><tr
id=sl_svn22_424

><td class="source"> <br></td></tr
><tr
id=sl_svn22_425

><td class="source"> &#39; &#39;   s t a r t i n g   a d d r e s s   i s   a d d r R e g .     T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e <br></td></tr
><tr
id=sl_svn22_426

><td class="source"> <br></td></tr
><tr
id=sl_svn22_427

><td class="source"> &#39; &#39;   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g .     T h i s   r e t u r n s   t r u e   i f   a n   e r r o r   o c c u r r e d . <br></td></tr
><tr
id=sl_svn22_428

><td class="source"> <br></td></tr
><tr
id=sl_svn22_429

><td class="source"> &#39; &#39;   N o t e   t h a t   t h e   w o r d   v a l u e   m a y   n o t   s p a n   a n   E E P R O M   p a g e   b o u n d a r y . <br></td></tr
><tr
id=sl_svn22_430

><td class="source"> <br></td></tr
><tr
id=sl_svn22_431

><td class="source">       i f   W r i t e P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   @ d a t a ,   2 ) <br></td></tr
><tr
id=sl_svn22_432

><td class="source"> <br></td></tr
><tr
id=sl_svn22_433

><td class="source">             r e t u r n   t r u e <br></td></tr
><tr
id=sl_svn22_434

><td class="source"> <br></td></tr
><tr
id=sl_svn22_435

><td class="source">       &#39;   j a m e s   e d i t   -   w a i t   f o r   5 m s   f o r   p a g e   w r i t e   t o   c o m p l e t e   ( 8 0 _ 0 0 0   *   5   =   4 0 0 _ 0 0 0 ) <br></td></tr
><tr
id=sl_svn22_436

><td class="source"> <br></td></tr
><tr
id=sl_svn22_437

><td class="source">       w a i t c n t ( 4 0 0 _ 0 0 0   +   c n t )             <br></td></tr
><tr
id=sl_svn22_438

><td class="source"> <br></td></tr
><tr
id=sl_svn22_439

><td class="source">       r e t u r n   f a l s e <br></td></tr
><tr
id=sl_svn22_440

><td class="source"> <br></td></tr
><tr
id=sl_svn22_441

><td class="source"> <br></td></tr
><tr
id=sl_svn22_442

><td class="source"> <br></td></tr
><tr
id=sl_svn22_443

><td class="source"> P U B   W r i t e L o n g ( S C L ,   d e v S e l ,   a d d r R e g ,   d a t a ) <br></td></tr
><tr
id=sl_svn22_444

><td class="source"> <br></td></tr
><tr
id=sl_svn22_445

><td class="source"> &#39; &#39;   W r i t e   o u t   a   s i n g l e   l o n g   o f   i 2 c   d a t a .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e <br></td></tr
><tr
id=sl_svn22_446

><td class="source"> <br></td></tr
><tr
id=sl_svn22_447

><td class="source"> &#39; &#39;   s t a r t i n g   a d d r e s s   i s   a d d r R e g .     T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e <br></td></tr
><tr
id=sl_svn22_448

><td class="source"> <br></td></tr
><tr
id=sl_svn22_449

><td class="source"> &#39; &#39;   u p p e r   3   b i t s   o f   t h e   1 9   b i t   a d d r R e g .     T h i s   r e t u r n s   t r u e   i f   a n   e r r o r   o c c u r r e d . <br></td></tr
><tr
id=sl_svn22_450

><td class="source"> <br></td></tr
><tr
id=sl_svn22_451

><td class="source"> &#39; &#39;   N o t e   t h a t   t h e   l o n g   w o r d   v a l u e   m a y   n o t   s p a n   a n   E E P R O M   p a g e   b o u n d a r y . <br></td></tr
><tr
id=sl_svn22_452

><td class="source"> <br></td></tr
><tr
id=sl_svn22_453

><td class="source">       i f   W r i t e P a g e ( S C L ,   d e v S e l ,   a d d r R e g ,   @ d a t a ,   4 ) <br></td></tr
><tr
id=sl_svn22_454

><td class="source"> <br></td></tr
><tr
id=sl_svn22_455

><td class="source">             r e t u r n   t r u e <br></td></tr
><tr
id=sl_svn22_456

><td class="source"> <br></td></tr
><tr
id=sl_svn22_457

><td class="source">       &#39;   j a m e s   e d i t   -   w a i t   f o r   5 m s   f o r   p a g e   w r i t e   t o   c o m p l e t e   ( 8 0 _ 0 0 0   *   5   =   4 0 0 _ 0 0 0 )             <br></td></tr
><tr
id=sl_svn22_458

><td class="source"> <br></td></tr
><tr
id=sl_svn22_459

><td class="source">       w a i t c n t ( 4 0 0 _ 0 0 0   +   c n t )             <br></td></tr
><tr
id=sl_svn22_460

><td class="source"> <br></td></tr
><tr
id=sl_svn22_461

><td class="source">       r e t u r n   f a l s e <br></td></tr
><tr
id=sl_svn22_462

><td class="source"> <br></td></tr
><tr
id=sl_svn22_463

><td class="source"> <br></td></tr
><tr
id=sl_svn22_464

><td class="source"> <br></td></tr
><tr
id=sl_svn22_465

><td class="source"> P U B   W r i t e W a i t ( S C L ,   d e v S e l ,   a d d r R e g )   :   a c k b i t <br></td></tr
><tr
id=sl_svn22_466

><td class="source"> <br></td></tr
><tr
id=sl_svn22_467

><td class="source"> &#39; &#39;   W a i t   f o r   a   p r e v i o u s   w r i t e   t o   c o m p l e t e .     D e v i c e   s e l e c t   c o d e   i s   d e v S e l .     D e v i c e <br></td></tr
><tr
id=sl_svn22_468

><td class="source"> <br></td></tr
><tr
id=sl_svn22_469

><td class="source"> &#39; &#39;   s t a r t i n g   a d d r e s s   i s   a d d r R e g .     T h e   d e v i c e   w i l l   n o t   r e s p o n d   i f   i t   i s   b u s y . <br></td></tr
><tr
id=sl_svn22_470

><td class="source"> <br></td></tr
><tr
id=sl_svn22_471

><td class="source"> &#39; &#39;   T h e   d e v i c e   s e l e c t   c o d e   i s   m o d i f i e d   u s i n g   t h e   u p p e r   3   b i t s   o f   t h e   1 8   b i t   a d d r R e g . <br></td></tr
><tr
id=sl_svn22_472

><td class="source"> <br></td></tr
><tr
id=sl_svn22_473

><td class="source"> &#39; &#39;   T h i s   r e t u r n s   z e r o   i f   n o   e r r o r   o c c u r r e d   o r   o n e   i f   t h e   d e v i c e   d i d n &#39; t   r e s p o n d . <br></td></tr
><tr
id=sl_svn22_474

><td class="source"> <br></td></tr
><tr
id=sl_svn22_475

><td class="source">       d e v S e l   | =   a d d r R e g   &gt; &gt;   1 5   &amp;   % 1 1 1 0 <br></td></tr
><tr
id=sl_svn22_476

><td class="source"> <br></td></tr
><tr
id=sl_svn22_477

><td class="source">       S t a r t ( S C L ) <br></td></tr
><tr
id=sl_svn22_478

><td class="source"> <br></td></tr
><tr
id=sl_svn22_479

><td class="source">       a c k b i t   : =   W r i t e ( S C L ,   d e v S e l   |   X m i t ) <br></td></tr
><tr
id=sl_svn22_480

><td class="source"> <br></td></tr
><tr
id=sl_svn22_481

><td class="source">       S t o p ( S C L ) <br></td></tr
><tr
id=sl_svn22_482

><td class="source"> <br></td></tr
><tr
id=sl_svn22_483

><td class="source">       r e t u r n   a c k b i t <br></td></tr
><tr
id=sl_svn22_484

><td class="source"> <br></td></tr
><tr
id=sl_svn22_485

><td class="source"> <br></td></tr
><tr
id=sl_svn22_486

><td class="source"> <br></td></tr
><tr
id=sl_svn22_487

><td class="source"> <br></td></tr
><tr
id=sl_svn22_488

><td class="source"> <br></td></tr
><tr
id=sl_svn22_489

><td class="source"> &#39;   * * * * * * * * * * * * * * *   J A M E S &#39; S   E x t r a   B I T S   * * * * * * * * * * * * * * * * * * * * * <br></td></tr
><tr
id=sl_svn22_490

><td class="source"> <br></td></tr
><tr
id=sl_svn22_491

><td class="source">       <br></td></tr
><tr
id=sl_svn22_492

><td class="source"> <br></td></tr
><tr
id=sl_svn22_493

><td class="source"> P U B   d e v i c e P r e s e n t ( S C L , d e v i c e A d d r e s s )   :   a c k b i t <br></td></tr
><tr
id=sl_svn22_494

><td class="source"> <br></td></tr
><tr
id=sl_svn22_495

><td class="source">     &#39;   s e n d   t h e   d e v i c e A d d r e s s   a n d   l i s t e n   f o r   t h e   A C K <br></td></tr
><tr
id=sl_svn22_496

><td class="source"> <br></td></tr
><tr
id=sl_svn22_497

><td class="source">       S t a r t ( S C L ) <br></td></tr
><tr
id=sl_svn22_498

><td class="source"> <br></td></tr
><tr
id=sl_svn22_499

><td class="source">       a c k b i t   : =   W r i t e ( S C L , d e v i c e A d d r e s s   |   0 ) <br></td></tr
><tr
id=sl_svn22_500

><td class="source"> <br></td></tr
><tr
id=sl_svn22_501

><td class="source">       S t o p ( S C L ) <br></td></tr
><tr
id=sl_svn22_502

><td class="source"> <br></td></tr
><tr
id=sl_svn22_503

><td class="source">       i f   a c k b i t   = =   A C K <br></td></tr
><tr
id=sl_svn22_504

><td class="source"> <br></td></tr
><tr
id=sl_svn22_505

><td class="source">           r e t u r n   t r u e <br></td></tr
><tr
id=sl_svn22_506

><td class="source"> <br></td></tr
><tr
id=sl_svn22_507

><td class="source">       e l s e <br></td></tr
><tr
id=sl_svn22_508

><td class="source"> <br></td></tr
><tr
id=sl_svn22_509

><td class="source">           r e t u r n   f a l s e <br></td></tr
><tr
id=sl_svn22_510

><td class="source"> <br></td></tr
><tr
id=sl_svn22_511

><td class="source"> <br></td></tr
><tr
id=sl_svn22_512

><td class="source"> <br></td></tr
><tr
id=sl_svn22_513

><td class="source"> P U B   w r i t e L o c a t i o n ( S C L , d e v i c e _ a d d r e s s ,   r e g i s t e r ,   v a l u e ) <br></td></tr
><tr
id=sl_svn22_514

><td class="source"> <br></td></tr
><tr
id=sl_svn22_515

><td class="source">     s t a r t ( S C L ) <br></td></tr
><tr
id=sl_svn22_516

><td class="source"> <br></td></tr
><tr
id=sl_svn22_517

><td class="source">     w r i t e ( S C L , d e v i c e _ a d d r e s s ) <br></td></tr
><tr
id=sl_svn22_518

><td class="source"> <br></td></tr
><tr
id=sl_svn22_519

><td class="source">     w r i t e ( S C L , r e g i s t e r ) <br></td></tr
><tr
id=sl_svn22_520

><td class="source"> <br></td></tr
><tr
id=sl_svn22_521

><td class="source">     w r i t e ( S C L , v a l u e )     <br></td></tr
><tr
id=sl_svn22_522

><td class="source"> <br></td></tr
><tr
id=sl_svn22_523

><td class="source">     s t o p   ( S C L ) <br></td></tr
><tr
id=sl_svn22_524

><td class="source"> <br></td></tr
><tr
id=sl_svn22_525

><td class="source"> <br></td></tr
><tr
id=sl_svn22_526

><td class="source"> <br></td></tr
><tr
id=sl_svn22_527

><td class="source"> P U B   r e a d L o c a t i o n ( S C L , d e v i c e _ a d d r e s s ,   r e g i s t e r )   :   v a l u e <br></td></tr
><tr
id=sl_svn22_528

><td class="source"> <br></td></tr
><tr
id=sl_svn22_529

><td class="source">     s t a r t ( S C L ) <br></td></tr
><tr
id=sl_svn22_530

><td class="source"> <br></td></tr
><tr
id=sl_svn22_531

><td class="source">     w r i t e ( S C L , d e v i c e _ a d d r e s s   |   0 ) <br></td></tr
><tr
id=sl_svn22_532

><td class="source"> <br></td></tr
><tr
id=sl_svn22_533

><td class="source">     w r i t e ( S C L , r e g i s t e r ) <br></td></tr
><tr
id=sl_svn22_534

><td class="source"> <br></td></tr
><tr
id=sl_svn22_535

><td class="source">     s t a r t ( S C L ) <br></td></tr
><tr
id=sl_svn22_536

><td class="source"> <br></td></tr
><tr
id=sl_svn22_537

><td class="source">     w r i t e ( S C L , d e v i c e _ a d d r e s s   |   1 )     <br></td></tr
><tr
id=sl_svn22_538

><td class="source"> <br></td></tr
><tr
id=sl_svn22_539

><td class="source">     v a l u e   : =   r e a d ( S C L , N A K ) <br></td></tr
><tr
id=sl_svn22_540

><td class="source"> <br></td></tr
><tr
id=sl_svn22_541

><td class="source">     s t o p ( S C L ) <br></td></tr
><tr
id=sl_svn22_542

><td class="source"> <br></td></tr
><tr
id=sl_svn22_543

><td class="source">     r e t u r n   v a l u e           <br></td></tr
></table></pre>
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
</td>
</tr></table>

 
<script type="text/javascript">
 var lineNumUnderMouse = -1;
 
 function gutterOver(num) {
 gutterOut();
 var newTR = document.getElementById('gr_svn22_' + num);
 if (newTR) {
 newTR.className = 'undermouse';
 }
 lineNumUnderMouse = num;
 }
 function gutterOut() {
 if (lineNumUnderMouse != -1) {
 var oldTR = document.getElementById(
 'gr_svn22_' + lineNumUnderMouse);
 if (oldTR) {
 oldTR.className = '';
 }
 lineNumUnderMouse = -1;
 }
 }
 var numsGenState = {table_base_id: 'nums_table_'};
 var srcGenState = {table_base_id: 'src_table_'};
 var alignerRunning = false;
 var startOver = false;
 function setLineNumberHeights() {
 if (alignerRunning) {
 startOver = true;
 return;
 }
 numsGenState.chunk_id = 0;
 numsGenState.table = document.getElementById('nums_table_0');
 numsGenState.row_num = 0;
 if (!numsGenState.table) {
 return; // Silently exit if no file is present.
 }
 srcGenState.chunk_id = 0;
 srcGenState.table = document.getElementById('src_table_0');
 srcGenState.row_num = 0;
 alignerRunning = true;
 continueToSetLineNumberHeights();
 }
 function rowGenerator(genState) {
 if (genState.row_num < genState.table.rows.length) {
 var currentRow = genState.table.rows[genState.row_num];
 genState.row_num++;
 return currentRow;
 }
 var newTable = document.getElementById(
 genState.table_base_id + (genState.chunk_id + 1));
 if (newTable) {
 genState.chunk_id++;
 genState.row_num = 0;
 genState.table = newTable;
 return genState.table.rows[0];
 }
 return null;
 }
 var MAX_ROWS_PER_PASS = 1000;
 function continueToSetLineNumberHeights() {
 var rowsInThisPass = 0;
 var numRow = 1;
 var srcRow = 1;
 while (numRow && srcRow && rowsInThisPass < MAX_ROWS_PER_PASS) {
 numRow = rowGenerator(numsGenState);
 srcRow = rowGenerator(srcGenState);
 rowsInThisPass++;
 if (numRow && srcRow) {
 if (numRow.offsetHeight != srcRow.offsetHeight) {
 numRow.firstChild.style.height = srcRow.offsetHeight + 'px';
 }
 }
 }
 if (rowsInThisPass >= MAX_ROWS_PER_PASS) {
 setTimeout(continueToSetLineNumberHeights, 10);
 } else {
 alignerRunning = false;
 if (startOver) {
 startOver = false;
 setTimeout(setLineNumberHeights, 500);
 }
 }
 }
 function initLineNumberHeights() {
 // Do 2 complete passes, because there can be races
 // between this code and prettify.
 startOver = true;
 setTimeout(setLineNumberHeights, 250);
 window.onresize = setLineNumberHeights;
 }
 initLineNumberHeights();
</script>

 
 
 <div id="log">
 <div style="text-align:right">
 <a class="ifCollapse" href="#" onclick="_toggleMeta('', 'p', 'spinneret-web-server', this)">Show details</a>
 <a class="ifExpand" href="#" onclick="_toggleMeta('', 'p', 'spinneret-web-server', this)">Hide details</a>
 </div>
 <div class="ifExpand">
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="changelog">
 <p>Change log</p>
 <div>
 <a href="/p/spinneret-web-server/source/detail?spec=svn22&amp;r=4">r4</a>
 by reltham
 on Jan 7, 2011
 &nbsp; <a href="/p/spinneret-web-server/source/diff?spec=svn22&r=4&amp;format=side&amp;path=/trunk/Basic_I2C_Driver.spin&amp;old_path=/trunk/Basic_I2C_Driver.spin&amp;old=">Diff</a>
 </div>
 <pre>Adding Initial versions of DHCP.spin and
s-35390A.spin</pre>
 </div>
 
 
 
 
 
 
 <script type="text/javascript">
 var detail_url = '/p/spinneret-web-server/source/detail?r=4&spec=svn22';
 var publish_url = '/p/spinneret-web-server/source/detail?r=4&spec=svn22#publish';
 // describe the paths of this revision in javascript.
 var changed_paths = [];
 var changed_urls = [];
 
 changed_paths.push('/trunk/Basic_I2C_Driver.spin');
 changed_urls.push('/p/spinneret-web-server/source/browse/trunk/Basic_I2C_Driver.spin?r\x3d4\x26spec\x3dsvn22');
 
 var selected_path = '/trunk/Basic_I2C_Driver.spin';
 
 
 changed_paths.push('/trunk/DHCP.spin');
 changed_urls.push('/p/spinneret-web-server/source/browse/trunk/DHCP.spin?r\x3d4\x26spec\x3dsvn22');
 
 
 changed_paths.push('/trunk/s-35390A.spin');
 changed_urls.push('/p/spinneret-web-server/source/browse/trunk/s-35390A.spin?r\x3d4\x26spec\x3dsvn22');
 
 
 function getCurrentPageIndex() {
 for (var i = 0; i < changed_paths.length; i++) {
 if (selected_path == changed_paths[i]) {
 return i;
 }
 }
 }
 function getNextPage() {
 var i = getCurrentPageIndex();
 if (i < changed_paths.length - 1) {
 return changed_urls[i + 1];
 }
 return null;
 }
 function getPreviousPage() {
 var i = getCurrentPageIndex();
 if (i > 0) {
 return changed_urls[i - 1];
 }
 return null;
 }
 function gotoNextPage() {
 var page = getNextPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoPreviousPage() {
 var page = getPreviousPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoDetailPage() {
 window.location = detail_url;
 }
 function gotoPublishPage() {
 window.location = publish_url;
 }
</script>

 
 <style type="text/css">
 #review_nav {
 border-top: 3px solid white;
 padding-top: 6px;
 margin-top: 1em;
 }
 #review_nav td {
 vertical-align: middle;
 }
 #review_nav select {
 margin: .5em 0;
 }
 </style>
 <div id="review_nav">
 <table><tr><td>Go to:&nbsp;</td><td>
 <select name="files_in_rev" onchange="window.location=this.value">
 
 <option value="/p/spinneret-web-server/source/browse/trunk/Basic_I2C_Driver.spin?r=4&amp;spec=svn22"
 selected="selected"
 >/trunk/Basic_I2C_Driver.spin</option>
 
 <option value="/p/spinneret-web-server/source/browse/trunk/DHCP.spin?r=4&amp;spec=svn22"
 
 >/trunk/DHCP.spin</option>
 
 <option value="/p/spinneret-web-server/source/browse/trunk/s-35390A.spin?r=4&amp;spec=svn22"
 
 >/trunk/s-35390A.spin</option>
 
 </select>
 </td></tr></table>
 
 
 



 
 </div>
 
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="older_bubble">
 <p>Older revisions</p>
 
 <a href="/p/spinneret-web-server/source/list?path=/trunk/Basic_I2C_Driver.spin&start=4">All revisions of this file</a>
 </div>
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="fileinfo_bubble">
 <p>File info</p>
 
 <div>Size: 25540 bytes,
 543 lines</div>
 
 <div><a href="//spinneret-web-server.googlecode.com/svn/trunk/Basic_I2C_Driver.spin">View raw file</a></div>
 </div>
 
 <div id="props">
 <p>File properties</p>
 <dl>
 
 <dt>svn:mime-type</dt>
 <dd>application/octet-stream</dd>
 
 </dl>
 </div>
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 </div>
 </div>


</div>

</div>
</div>


<script src="http://www.gstatic.com/codesite/ph/9104208085135278598/js/source_file_scripts.js"></script>

 <script type="text/javascript" src="https://kibbles.googlecode.com/files/kibbles-1.3.3.comp.js"></script>
 <script type="text/javascript">
 var lastStop = null;
 var initialized = false;
 
 function updateCursor(next, prev) {
 if (prev && prev.element) {
 prev.element.className = 'cursor_stop cursor_hidden';
 }
 if (next && next.element) {
 next.element.className = 'cursor_stop cursor';
 lastStop = next.index;
 }
 }
 
 function pubRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftDestroyed(data) {
 updateCursorForCell(data.cellId, 'nocursor');
 if (initialized) {
 reloadCursors();
 }
 }
 function reloadCursors() {
 kibbles.skipper.reset();
 loadCursors();
 if (lastStop != null) {
 kibbles.skipper.setCurrentStop(lastStop);
 }
 }
 // possibly the simplest way to insert any newly added comments
 // is to update the class of the corresponding cursor row,
 // then refresh the entire list of rows.
 function updateCursorForCell(cellId, className) {
 var cell = document.getElementById(cellId);
 // we have to go two rows back to find the cursor location
 var row = getPreviousElement(cell.parentNode);
 row.className = className;
 }
 // returns the previous element, ignores text nodes.
 function getPreviousElement(e) {
 var element = e.previousSibling;
 if (element.nodeType == 3) {
 element = element.previousSibling;
 }
 if (element && element.tagName) {
 return element;
 }
 }
 function loadCursors() {
 // register our elements with skipper
 var elements = CR_getElements('*', 'cursor_stop');
 var len = elements.length;
 for (var i = 0; i < len; i++) {
 var element = elements[i]; 
 element.className = 'cursor_stop cursor_hidden';
 kibbles.skipper.append(element);
 }
 }
 function toggleComments() {
 CR_toggleCommentDisplay();
 reloadCursors();
 }
 function keysOnLoadHandler() {
 // setup skipper
 kibbles.skipper.addStopListener(
 kibbles.skipper.LISTENER_TYPE.PRE, updateCursor);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_top', 50);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_bottom', 100);
 // Register our keys
 kibbles.skipper.addFwdKey("n");
 kibbles.skipper.addRevKey("p");
 kibbles.keys.addKeyPressListener(
 'u', function() { window.location = detail_url; });
 kibbles.keys.addKeyPressListener(
 'r', function() { window.location = detail_url + '#publish'; });
 
 kibbles.keys.addKeyPressListener('j', gotoNextPage);
 kibbles.keys.addKeyPressListener('k', gotoPreviousPage);
 
 
 }
 </script>
<script src="http://www.gstatic.com/codesite/ph/9104208085135278598/js/code_review_scripts.js"></script>
<script type="text/javascript">
 function showPublishInstructions() {
 var element = document.getElementById('review_instr');
 if (element) {
 element.className = 'opened';
 }
 }
 var codereviews;
 function revsOnLoadHandler() {
 // register our source container with the commenting code
 var paths = {'svn22': '/trunk/Basic_I2C_Driver.spin'}
 codereviews = CR_controller.setup(
 {"token":"68f59d006ed24ca23ddbcf9440ea0c2a","assetHostPath":"http://www.gstatic.com/codesite/ph","domainName":null,"assetVersionPath":"http://www.gstatic.com/codesite/ph/9104208085135278598","projectName":"spinneret-web-server","projectHomeUrl":"/p/spinneret-web-server","absoluteBaseUrl":"http://code.google.com","relativeBaseUrl":"","urlPrefix":"p","loggedInUserEmail":"ben@byaroch.com"}, '', 'svn22', paths,
 CR_BrowseIntegrationFactory);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, showPublishInstructions);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_PUB_PLATE, pubRevealed);
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, draftRevealed);
 codereviews.registerActivityListener(CR_ActivityType.DISCARD_DRAFT_COMMENT, draftDestroyed);
 
 
 
 
 
 
 
 var initialized = true;
 reloadCursors();
 }
 window.onload = function() {keysOnLoadHandler(); revsOnLoadHandler();};

</script>
<script type="text/javascript" src="http://www.gstatic.com/codesite/ph/9104208085135278598/js/dit_scripts.js"></script>

 
 
 
 <script type="text/javascript" src="http://www.gstatic.com/codesite/ph/9104208085135278598/js/ph_core.js"></script>
 
 
 
 
 <script type="text/javascript" src="/js/codesite_product_dictionary_ph.pack.04102009.js"></script>
</div> 
<div id="footer" dir="ltr">
 <div class="text">
 &copy;2011 Google -
 <a href="/projecthosting/terms.html">Terms</a> -
 <a href="http://www.google.com/privacy.html">Privacy</a> -
 <a href="/p/support/">Project Hosting Help</a>
 </div>
</div>
 <div class="hostedBy" style="margin-top: -20px;">
 <span style="vertical-align: top;">Powered by <a href="http://code.google.com/projecthosting/">Google Project Hosting</a></span>
 </div>
 
 


 
 </body>
</html>

