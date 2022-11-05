import qrcodeprocessing.*;
PImage img; 
Decoder decoder;

void setup() {
  size(400, 400);
  img = loadImage("qr_dpsd19049.png");
  decoder = new Decoder(this);
  decoder.decodeImage(img);
}
void decoderEvent(Decoder decoder) {
  String statusMsg = decoder.getDecodedString(); 
  println(statusMsg);
  link(statusMsg);
}

void draw() {
  image(img, 0, 0, width, height);
}
