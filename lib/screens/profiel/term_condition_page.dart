import 'package:flutter/material.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({Key? key}) : super(key: key);

  final privacy =
      "At www.candotoday.com, accessible from info@candotoday.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by www.candotoday.com and how we use it.If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in www.candotoday.com. This policy is not applicable to any information collected offline or via channels other than this website. Our Privacy Policy was created with the help of the Free Privacy Policy Generator.ConsentBy using our website, you hereby consent to our Privacy Policy and agree to its terms.Information we collectThe personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide.When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number.How we use your informationWe use the information we collect in various ways, including to:    Provide, operate, and maintain our website    Improve, personalize, and expand our website    Understand and analyze how you use our website    Develop new products, services, features, and functionality    Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the website, and for marketing and promotional purposes    Send you emails    Find and prevent fraudLog Fileswww.candotoday.com follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users movement on the website, and gathering demographic information.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: ListView(children: [
        Container(
          height: 200,
          //color: Colors.blue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/images/aclogo.png")),
                SizedBox(
                  height: 20,
                ),
                Text("Can Do Today 1.0")
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Text(
            privacy,
            style: TextStyle(fontSize: 18),
          ),
        )
      ]),
    );
  }
}
