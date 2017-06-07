using UnityEngine;
using System.Collections;

[RequireComponent(typeof(SpriteRenderer))]
[RequireComponent(typeof(CircleCollider2D))]
public class TapCircle : MonoBehaviour
{
    SpriteRenderer mSpriteRenderer;
    CircleCollider2D mCircleCollider;
    public float mAnimationTime = 0.4f; //タップアニメーション時間

    void Awake()
    {
        mSpriteRenderer = transform.GetComponent<SpriteRenderer>();
        mCircleCollider = transform.GetComponent<CircleCollider2D>();
    }

    void Start()
    {
        Invoke("unenabledTrigger", 0.05f);

        mSpriteRenderer.material.SetFloat("_StartTime", Time.time);
        mSpriteRenderer.material.SetFloat("_AnimationTime", mAnimationTime);
        Destroy(transform.gameObject, mAnimationTime);
    }

    public void unenabledTrigger()
    {
        mCircleCollider.enabled = false;
    }

    public void OnTriggerEnter2D(Collider2D collider)
    {
        //タップしたオブジェクト : collider

        //-----------------処理-----------------//

    }
}