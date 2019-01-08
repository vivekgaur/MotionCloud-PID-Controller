/**
 * Created by gopinath on 7/16/16.
 */
import java.util.ArrayList;


class Queue<T> extends ArrayList<T> {
    private int limit = 100;


    public boolean add(T val) {

        if (this.size() >= this.limit) {
            this.remove(0);
        }
        super.add(val);
        return true;
    }

    private static void printQueue(Queue<?> queue) {
        for(int i = 0; i < queue.size(); i++)
            System.out.println("Index : " + i + " " + queue.get(i));
    }
    public void setLimit(int limit) {
        this.limit = limit;
    }
    public int getLimit() {
        return this.limit;
    }
    public static void main(String[] args) {

        Queue<IMUData> q = new Queue();
        for (int i = 0 ; i < 200; i++) {
            IMUData p = IMUData.generateRandomIMUData(1, 20);
            q.add(p);
        }
        Queue.printQueue(q);
    }
}