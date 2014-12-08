public class fpgdxt{

  public static native void mainproc();

  public static void main(String[] args)

  {
  System.loadLibrary("fpgdxt");
  mainproc();
  }
}
