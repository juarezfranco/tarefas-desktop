
namespace App.Interfaces {

    public interface Model : GLib.Object {

        public abstract int id { get; set; }
        public abstract DateTime created_at { get; set; }
        public abstract DateTime updated_at { get; set; }
        public abstract DateTime deleted_at { get; set; }

        public void set_created_at_from_int64 (int64 num) {
            this.created_at = new DateTime.from_unix_local (num);
        }

        public void set_updated_at_from_int64 (int64 num) {
            this.updated_at = new DateTime.from_unix_local (num);
        }

        public void set_deleted_at_from_int64 (int64 num) {
            this.deleted_at = new DateTime.from_unix_local (num);
        }
    }
}
