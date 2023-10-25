String imageUrl =
    'https://img.freepik.com/premium-vector/young-boy-looking-phone-semi-flat-color-vector-character-sitting-figure-full-body-person-white-late-adolescence-isolated-modern-cartoon-style-illustration-graphic-design-animation_151150-8054.jpg';




/*

Backend Code to generate tocken (Node JS)
_________________________________________________________




//  router.post("/agoraToken",tokenGeneration)


export const tokenGeneration = (req, res) => {
  try {
    const {  channelName } = req.body;
    const uid = 0
    var appID = "26053c3e0f544c3f9b70e4d96548a613";
    var appCertificate = "4386c6d578834a17b0f2d46dc2bd0fa8";
    var expirationTimeInSeconds = 3600;
    var role = RtcRole.PUBLISHER;
    var currentTimestamp = Math.floor(Date.now() / 1000);
    var privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    // use 0 if uid is not specified

    if (!channelName) {
      return res.status(400).json({ error: "channel name is required" }).send();
    }

    var key = RtcTokenBuilder.buildTokenWithUid(
      appID,
      appCertificate,
      channelName,
     uid,
      role,
      privilegeExpiredTs
    );
    console.log(key);
    res.header("Access-Control-Allow-Origin", "*");
    //resp.header("Access-Control-Allow-Origin", "http://ip:port")
    return res.json({ key: key }).send();
  } catch (error) {
    res
      .status(500)
      .json({ message: "Something went wrong, Please try again later" });
  }
};

____________________________________________________________________________

Reference : 
https://www.npmjs.com/package/agora-access-token


*/