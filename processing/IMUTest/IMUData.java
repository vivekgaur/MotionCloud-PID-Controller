import java.util.Random;

/**
 * Created by gopinath on 7/16/16.
 */
class IMUData {

    public double x;
    public double y;
    public double z;
    public long time;

    public IMUData() {

    }
    public  IMUData(double x, double y, double z, long time) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.time = time;
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

    public void setZ(double z) {
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
        return "IMUData{" +
                "x=" + x +
                ", y=" + y +
                ", z=" + z +
                ", time=" + time +
                '}';
    }
    public static IMUData generateRandomIMUData(double min, double max) {
        Random rand = new Random();
        return new IMUData( min + (max - min) * rand.nextDouble(),
                             min + (max - min) * rand.nextDouble(),
                             min + (max - min) * rand.nextDouble(),
                             100);

    }
}