import java.util.Random;

/**
 * Created by gopinath on 7/16/16.
 */
class Quaternion {
    
    public double w;
    public double x;
    public double y;
    public double z;
    public long time;

    public Quaternion() {

    }
    public  Quaternion(double w, double x, double y, double z, long time) {
        this.w = w;
        this.x = x;
        this.y = y;
        this.z = z;
        this.time = time;
    }

    public double getW() {
        return w;
    }

    public void setW(double w) {
        this.w = w;
    }
    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }

    public double getY() {
        return y;
    }

    public void setY(double y) {
        this.y = y;
    }

    public double getZ() {
        return z;
    }

    public void setZ(float z) {
        this.z = z;
    }
     public long getTime() {
        return time;
    }

    public void setTime(long time) {
        this.time = time;
    }
    @Override
    public String toString() {
        return "Quaternion{" +
                "w=" + w +
                "x=" + x +
                ", y=" + y +
                ", z=" + z +
                ", time=" + time +
                '}';
    }
    public static Quaternion generateRandomQuaternion(double min, double max) {
        Random rand = new Random();
        return new Quaternion( min + (max - min) * rand.nextDouble(),
                             min + (max - min) * rand.nextDouble(),
                             min + (max - min) * rand.nextDouble(),
                             min + (max - min) * rand.nextDouble(),
                             100);

    }
}