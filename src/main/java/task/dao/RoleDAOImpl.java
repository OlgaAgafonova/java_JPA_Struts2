package task.dao;

import org.hibernate.SessionFactory;
import task.entity.Role;

import java.util.List;

/**
 * Created by Оля on 09.07.2016.
 */
public class RoleDAOImpl implements RoleDAO {

    private SessionFactory sessionFactory;

    @Override
    public void addRole(Role role) {
        this.sessionFactory.getCurrentSession().save(role);
    }

    @Override
    public List getAllRoles() {
        return this.sessionFactory.getCurrentSession().createQuery("from Role ").list();
    }

    @Override
    public Role getRoleByName(String name) {
        return (Role)this.sessionFactory.getCurrentSession().createQuery("from Role where name = ?").setString(0,name).uniqueResult();
    }

    @Override
    public Role getRoleById(Integer id) {
        return (Role)this.sessionFactory.getCurrentSession().createQuery("from Role where id = ?").setInteger(0,id).uniqueResult();
    }

    @Override
    public void deleteRoleByID(Integer roleId) {
        Role role = (Role) this.sessionFactory.getCurrentSession().load(Role.class, roleId);
        if (role != null) {
            this.sessionFactory.getCurrentSession().delete(role);
        }
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }
}
