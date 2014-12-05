public class fpguidesignerext{

  public static native void mainproc();

  public static void main(String[] args)

  {
  System.loadLibrary("fpguidesignerext");
  mainproc();
  }
}
