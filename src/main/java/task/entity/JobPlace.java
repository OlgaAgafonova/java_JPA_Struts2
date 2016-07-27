package task.entity;


import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "JOB_PLACE")
public class JobPlace {

    @Id
    @Column(name = "ID")
    @GeneratedValue
    private Integer id;

    @Temporal(TemporalType.DATE)
    @Column(name = "START_DATE")
    private Date start;

    @Temporal(TemporalType.DATE)
    @Column(name = "END_DATE")
    private Date end;

    @Column(name = "ID_USER")
    private Integer id_user;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ID_ORGANIZATION")
    private Organization organization;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ID_POSITION")
    private Position position;

    @Column(name = "TYPE", columnDefinition = "TINYINT", nullable = false)
    private byte type;

    public JobPlace() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public Integer getId_user() {
        return id_user;
    }

    public void setId_user(Integer id_user) {
        this.id_user = id_user;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }

    public byte getType() {
        return type;
    }

    public void setType(byte type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "JobPlace{"
                + "start=" + start
                + ", end=" + end
                + ", id_user=" + id_user
                + ", organization=" + organization
                + ", position=" + position
                + '}';
    }
}
