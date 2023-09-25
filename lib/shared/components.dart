import 'package:flutter/material.dart';

Widget defaultButton({
  Color background = Colors.blue,
  double width = double.infinity,
  double height = 45,
  required String? text,
  double radius = 0,
  void Function()? function,
}) =>
    Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text!.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
    );

Widget defaultTextForm({
  required TextEditingController? controller,
  required TextInputType? type,
  Function(String)? onSubmit,
  Function(String)? onchange,
  required String? label,
  void Function()? onTap,
  required Widget? pre,
  IconData? suf,
  required String? Function(String?)? validate,
  bool isPassword = false,
  bool obsecure = false,
  Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      enabled: isClickable,
      obscureText: isPassword ? true : false,
      onFieldSubmitted: onSubmit,
      onChanged: onchange,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(),
        prefixIcon: pre,
        suffixIcon: suf != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suf),
              )
            : null,
      ),
      validator: validate,
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

Widget BuildListProduct(model, context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120,
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage('${model!.product!.image}'),
                    width: double.infinity,
                  ),
                  if (model.product!.discount != 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.red,
                      child: Text(
                        'DISCOUNT',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.product!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        model.product!.price.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if (model.product!.discount != 0)
                        Text(
                          model.product!.oldPrice.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.shopping_cart_checkout,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget BuildStoryItem() => Container(
      height: 150,
      width: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: AssetImage(
              "assets/images/facebookStory.jpg",
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Color(0xff0074d1),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 25,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 22),
              child: Text(
                "owner",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        )
      ]),
    );

Widget BuildPostItem() => Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 45,
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Owner",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "3h",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.public,
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "My Post",
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "100",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: 40,
                height: 25,
                child: Image(
                  image: AssetImage("assets/images/like.jpg"),
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "100 Comments",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            color: Colors.grey,
            child: Row(
              children: [],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Image(
                            height: 50,
                            width: 20,
                            image: AssetImage("assets/images/singleLike.jpg"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Like")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Image(
                            height: 50,
                            width: 20,
                            image: AssetImage("assets/images/comment.jpg"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Like")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Image(
                            height: 50,
                            width: 20,
                            image: AssetImage("assets/images/share.png"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Like")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey,
            child: Row(
              children: [],
            ),
          ),
        ],
      ),
    );

Widget BuildCourseItem(
        {required String CourseName,
        required String ImagePath,
        required Function onPressed}) =>
    Container(
      width: double.infinity,
      child: Column(
        children: [
          Image(
            width: double.infinity,
            height: 200,
            image: AssetImage("$ImagePath"),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onPressed();
              },
              child: Text(
                "$CourseName",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff114acc),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );

